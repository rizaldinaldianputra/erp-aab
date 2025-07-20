import 'dart:developer';
import 'dart:io';

import 'package:attendance/attendance.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:files/files.dart';
import 'package:flutter/material.dart';
import 'package:home_employee/home.dart';
import 'package:leave/leave.dart';
import 'package:main/main.dart';
import 'package:notice/notice.dart';
import 'package:payroll/payroll.dart';
import 'package:profile/profile.dart';
import 'package:resign/resign.dart';
import 'package:settings/settings.dart';
import 'package:trackingworks/app/http_error_report_interceptor.dart';
import 'package:dio/dio.dart';

import '../config/config.dart';

final getIt = GetIt.instance;

/// Setup Global Dependency Injection
Future<void> setupGlobalDI() async {
  // ---------- CORE MODULE ----------
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();

  final cacheManager = await CacheManagerImpl.setup(
    encryptKey: BaseConfig.encryptDBKey,
  );
  getIt.registerLazySingleton<CacheManager>(() => cacheManager);

  await _setupConfiguration();

  getIt.registerLazySingleton<GlobalKey<NavigatorState>>(
    () => GlobalKey<NavigatorState>(),
  );
  getIt.registerLazySingleton<GlobalKey<ScaffoldMessengerState>>(
    () => GlobalKey<ScaffoldMessengerState>(),
  );
  getIt.registerFactory<RouteSettings>(() => RouteSettings());

  final baseUrl = getIt<GlobalConfiguration>().getValue('base_url');
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  dio.interceptors.addAll([
    AuthHttpInterceptor(
      cacheManager: getIt(),
      onUnAuth: () {
        // TODO: handle unauthorized access globally
      },
    ),
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (v) => log(v.toString()),
    ),
    HttpErrorReportInterceptor(),
  ]);

  getIt.registerLazySingleton<Dio>(() => dio);

  _fixBadHttpCertificate();

  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker(),
  );
  // ---------- END CORE MODULE ----------

  // ---------- FEATURE MODULE ----------
  AuthModule().inject(getIt);
  HomeModule().inject(getIt);
  MainModule().inject(getIt);
  SettingsModule().inject(getIt);
  ProfileModule().inject(getIt);
  AttendanceModule().inject(getIt);
  NoticeModule().inject(getIt);
  LeaveModule().inject(getIt);
  ResignModule().inject(getIt);
  PayrollModule().inject(getIt);
  FilesModule().inject(getIt);
  // ---------- END FEATURE MODULE ----------
}

/// Setup configuration based on flavor (DEV, STAGING, PROD)
Future<void> _setupConfiguration() async {
  late GlobalConfiguration globalConfig;

  switch (F.flavor) {
    case Flavor.DEV:
      globalConfig = await GlobalConfiguration.setup('assets/cfg/env-dev.json');
      break;
    case Flavor.STAGING:
      globalConfig =
          await GlobalConfiguration.setup('assets/cfg/env-staging.json');
      break;
    case Flavor.PROD:
      globalConfig =
          await GlobalConfiguration.setup('assets/cfg/env-prod.json');
      break;
  }

  final packageInfo = await PackageInfo.fromPlatform();
  globalConfig.setValue('version_name', packageInfo.version);

  getIt.registerLazySingleton<GlobalConfiguration>(() => globalConfig);
}

/// Allow self-signed or bad SSL certificates (for development only!)
void _fixBadHttpCertificate() {
  final dio = GetIt.I<Dio>();
  // (dio.httpClientAdapter) = (HttpClient client) {
  //   client.badCertificateCallback =
  //       (X509Certificate cert, String host, int port) => true;
  //   return client;
  // };
}
