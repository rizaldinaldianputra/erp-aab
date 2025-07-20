import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:trackingworks/run_app.dart';
import 'config/config.dart';
import 'di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  F.flavor = Flavor.PROD;
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await _configureLocalTimeZone();
  await _initializeNotifications();

  final prefs = await SharedPreferences.getInstance();
  final hasStartDate = prefs.getString('starttime') != null &&
      prefs.getString('starttime')!.isNotEmpty;
  final hasEndDate = prefs.getString('endtime') != null &&
      prefs.getString('endtime')!.isNotEmpty;

  if (hasStartDate) {
    await scheduleStartTimeNotification();
  }
  if (hasEndDate) {
    await scheduleEndTimeNotification();
  }

  await setupGlobalDI();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://eef76dbaace44f61b1fb8bf7fbc990a1@o910762.ingest.sentry.io/5989350';
      options.debug = kDebugMode;
      options.environment = 'Qerja.io';
      options.release = GetIt.I<GlobalConfiguration>().getValue('version_name');
      options.sampleRate = 0.25;
    },
    appRunner: () => runAppWithRecordError(),
  );
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
}

Future<void> _initializeNotifications() async {
  final status = await Permission.notification.request();
  if (!status.isGranted) {
    print('❌ Izin notifikasi ditolak.');
    return;
  }

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
  print('✅ Plugin notifikasi berhasil diinisialisasi.');
}

Future<void> scheduleStartTimeNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('starttime');

  print('Cek starttime: $raw');
  if (raw == null || raw.isEmpty) return;

  try {
    final parts = raw.split(':');
    if (parts.length < 2) return;

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final now = tz.TZDateTime.now(tz.local);
    final notifTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).subtract(const Duration(minutes: 15));

    if (now.isAfter(notifTime)) {
      print('🔕 Lewat dari 15 menit sebelum   . Tidak menampilkan notifikasi.');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'start_time_channel_id',
      'Pengingat Absen Masuk',
      channelDescription: 'Channel untuk notifikasi pengingat absen masuk.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ticker: 'ticker',
    );

    const notifDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Reminder Absen Masuk',
      'Jangan lupa absen masuk! Sesi Anda dimulai dalam 15 menit.',
      notifTime,
      notifDetails,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );

    print('✅ Notifikasi MASUK dijadwalkan pada ${notifTime.toLocal()}');
  } catch (e) {
    print('❌ Gagal menjadwalkan notifikasi MASUK: $e');
  }
}

Future<void> scheduleEndTimeNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('endtime');

  print('Cek endtime: $raw');
  if (raw == null || raw.isEmpty) return;

  try {
    final parts = raw.split(':');
    if (parts.length < 2) return;

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final now = tz.TZDateTime.now(tz.local);
    var notifTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).subtract(const Duration(minutes: 15));

    if (now.isAfter(notifTime)) {
      print(
          '🔕 Lewat dari 15 menit sebelum endtime. Tidak menampilkan notifikasi.');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'end_time_channel_id',
      'Pengingat Absen Pulang',
      channelDescription: 'Channel untuk notifikasi pengingat absen pulang.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ticker: 'ticker',
    );

    const notifDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder Absen Pulang',
        'Jangan lupa absen pulang! Sesi Anda akan berakhir 15 menit lagi.',
        notifTime,
        notifDetails,
        androidScheduleMode: AndroidScheduleMode.alarmClock);

    print('✅ Notifikasi PULANG dijadwalkan pada ${notifTime.toLocal()}');
  } catch (e) {
    print('❌ Gagal menjadwalkan notifikasi PULANG: $e');
  }
}
