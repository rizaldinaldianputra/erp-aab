import 'dart:convert';
import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:settings/settings.dart';

import '../../auth.dart';

/// Error handling when error in interceptor about authentication
class AuthHttpInterceptor extends InterceptorsWrapper {
  /// Repository to get data current token
  final CacheManager cacheManager;
  final VoidCallback? onUnAuth;

  ///
  AuthHttpInterceptor({required this.cacheManager, this.onUnAuth});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await cacheManager.read(AuthConfig.tokenCacheKey);
    final languageCode = await _getLanguageCode();

    final _optionHeaders = <String, Object>{};

    if (options.headers['unAuthorize'] != true) {
      _optionHeaders.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    _optionHeaders.putIfAbsent('user-device', () => Uuid().v4());

    _optionHeaders.putIfAbsent('Accept-Language',
        () => languageCode ?? SettingConfig.defaultCountry.code);

    options.headers.addAll(_optionHeaders);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ath", 'Bearer $token');
    prefs.setString("dvc", Uuid().v4());
    prefs.setString("lg", SettingConfig.defaultCountry.code);
    handler.next(options);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    final isError403 = (err.response?.statusCode == 403 &&
        err.requestOptions.headers['ignore_403'] != true);

    final isError401 = (err.response?.statusCode == 401 &&
        err.requestOptions.headers['ignore_401'] != true);

    if (isError401 || isError403) {
      GetIt.I<AuthBloc>()
        ..add(AuthLogoutEvent())
        ..add(AuthInitializeEvent());
      final key = GetIt.I<GlobalKey<NavigatorState>>();
      if (key.currentContext != null) {
        Navigator.of(key.currentContext!).popUntil(ModalRoute.withName('/'));
      }
      onUnAuth?.call();
    }
    handler.next(err);
  }

  Future<String?> _getLanguageCode() async {
    try {
      final _result = await cacheManager.read(SettingConfig.languageCacheKey);
      if (_result != null && _result is String) {
        final country = CountryModel.fromJson(json.decode(_result));
        return country.code;
      }
    } catch (e) {
      log('ERROR: $e');
    }
    return null;
  }
}
