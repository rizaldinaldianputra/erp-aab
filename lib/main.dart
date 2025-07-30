import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:trackingworks/firebase_options.dart';
import 'package:trackingworks/run_app.dart';
import 'config/config.dart';
import 'di/injection.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:sentry_flutter/sentry_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  F.flavor = Flavor.PROD;

  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // jika pakai firebase_options.dart
  );
  _configureLocalTimeZone();
  await setupGlobalDI();
  await SentryFlutter.init((options) {
    options.dsn =
        'https://eef76dbaace44f61b1fb8bf7fbc990a1@o910762.ingest.sentry.io/5989350';
    options.debug = kDebugMode;
    options.environment = 'Qerja.io';
    options.release = GetIt.I<GlobalConfiguration>().getValue('version_name');
    options.sampleRate = 0.25;
  }, appRunner: () => runAppWithRecordError());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
}
