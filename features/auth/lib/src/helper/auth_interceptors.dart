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

    final deviceId = await _getDeviceID();

    final _optionHeaders = <String, Object>{};

    if (options.headers['unAuthorize'] != true) {
      _optionHeaders.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    if (deviceId != null) {
      _optionHeaders.putIfAbsent('user-device', () => deviceId);
    }

    _optionHeaders.putIfAbsent('Accept-Language',
        () => languageCode ?? SettingConfig.defaultCountry.code);

    options.headers.addAll(_optionHeaders);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ath", 'Bearer $token');
    prefs.setString("dvc", deviceId ?? Uuid().v4());
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

  Future<String?> _getDeviceID() async {
    final _config = GetIt.I<GlobalConfiguration>();
    final cachedDeviceId = _config.getValue('DEVICE_ID');

    if (cachedDeviceId != null &&
        cachedDeviceId != 'null' &&
        cachedDeviceId is String) {
      return cachedDeviceId;
    } else {
      try {
        final result = await GetIt.I<FlutterDeviceId>().deviceId;
        log('DEVICE ID: $result');

        String finalDeviceId;

        if (result != null && result != 'null') {
          finalDeviceId = result;
        } else {
          finalDeviceId =
              const Uuid().v4(); // generate UUID jika device ID kosong/null
          log('Generated UUID v4: $finalDeviceId');

          GetIt.I<RecordErrorUseCase>()(
            RecordErrorParams(
              library: 'Flutter Device Id',
              tags: const ['Flutter Device Id'],
              exception: Exception('Device ID is null, using UUID instead'),
              stackTrace: StackTrace.current,
              errorMessage: 'Device ID is null, using UUID instead',
            ),
          );
        }

        _config.setValue('DEVICE_ID', finalDeviceId);
        return finalDeviceId;
      } catch (e, stackTrace) {
        final fallbackId = const Uuid().v4();
        log('ERROR getting device ID: $e, fallback UUID: $fallbackId');

        GetIt.I<RecordErrorUseCase>()(
          RecordErrorParams(
            library: 'Flutter Device Id',
            tags: const ['Flutter Device Id'],
            exception: e is Exception ? e : Exception(e.toString()),
            stackTrace: stackTrace,
            errorMessage:
                'Exception occurred while fetching device ID, fallback UUID used',
          ),
        );

        _config.setValue('DEVICE_ID', fallbackId);
        return fallbackId;
      }
    }
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
