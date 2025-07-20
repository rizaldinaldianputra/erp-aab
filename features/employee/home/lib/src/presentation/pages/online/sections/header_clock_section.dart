import 'package:attendance/attendance.dart';
import 'package:auth/auth.dart';
import 'package:component/component.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:preferences/preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../../../home.dart';

class HeaderClockSection extends StatefulWidget {
  final VoidCallback? onTapClockIn;
  final VoidCallback? onTapClockOut;
  final VoidCallback? onSlideBreakTime;

  const HeaderClockSection(
      {Key? key, this.onTapClockIn, this.onTapClockOut, this.onSlideBreakTime})
      : super(key: key);

  @override
  _HeaderClockSectionState createState() => _HeaderClockSectionState();
}

class _HeaderClockSectionState extends State<HeaderClockSection> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    tz.initializeTimeZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleBloc, ScheduleState>(
      listenWhen: (prev, current) => prev != current,
      listener: (context, state) async {
        if (state is ScheduleSuccess && state.data.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();

          final startTimeString = state.data.first.timeStart!;
          final endTimeString = state.data.first.timeEnd!;

          await prefs.remove('starttime');
          await prefs.remove('endtime');

          // Simpan ke SharedPreferences
          await prefs.setString('starttime', startTimeString);
          await prefs.setString('endtime', endTimeString);

          // Ambil kembali dari SharedPreferences
          final savedStartTime = prefs.getString('starttime');
          final savedEndTime = prefs.getString('endtime');

          if (savedStartTime != null && savedEndTime != null) {
            final now = DateTime.now();

            final startParts =
                savedStartTime.split(':').map(int.parse).toList();
            final endParts = savedEndTime.split(':').map(int.parse).toList();

            final startDateTime = DateTime(
              now.year,
              now.month,
              now.day,
              startParts[0],
              startParts[1],
              startParts.length > 2 ? startParts[2] : 0,
            );

            final endDateTime = DateTime(
              now.year,
              now.month,
              now.day,
              endParts[0],
              endParts[1],
              endParts.length > 2 ? endParts[2] : 0,
            );

            final startNotifTime =
                startDateTime.subtract(const Duration(minutes: 15));
            final endNotifTime =
                endDateTime.subtract(const Duration(minutes: 15));

            // if (startNotifTime.isAfter(now)) {
            //   await scheduleNotification(
            //     startNotifTime,
            //     'Reminder Absen Masuk',
            //     'Jangan lupa absen masuk! Sesi Anda dimulai dalam 15 menit.',
            //   );
            // }

            // if (endNotifTime.isAfter(now)) {
            //   await scheduleNotification(
            //     endNotifTime,
            //     'Reminder Absen Pulang',
            //     'Jangan lupa absen pulang! Sesi Anda akan berakhir 15 menit lagi.',
            //   );
            // }

            // Tampilkan dialog konfirmasi
            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     title: const Text('Berhasil Disimpan'),
            //     content: Text(
            //       'Waktu notifikasi berhasil disimpan:\n\n'
            //       'Start Time: $savedStartTime\n'
            //       'End Time:   $savedEndTime\n\n'
            //       'Notifikasi akan muncul 15 menit sebelumnya.',
            //     ),
            //     actions: [
            //       TextButton(
            //         onPressed: () => Navigator.of(context).pop(),
            //         child: const Text('OK'),
            //       ),
            //     ],
            //   ),
            // );
          }
        }
      },
      child: Column(
        children: [
          BlocBuilder<ScheduleBloc, ScheduleState>(
            buildWhen: (prev, current) => prev != current,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SubTitle1Text(
                          DateFormat('EEE, d MMM y')
                              .format(DateTime.now())
                              .toString(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildSchedule(state),
                    ],
                  ),
                  const SizedBox(height: Dimens.dp8),
                  _buildProfileCard(),
                  _buildWarning(),
                  const SizedBox(height: Dimens.dp12),
                  _buildBtnClockIn(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSchedule(ScheduleState state) {
    if (state is ScheduleSuccess) {
      if (state.data.isNotEmpty) {
        print(state.data.first.timeEnd);
        return TitleText(
          '${Utils.durationToClock(
            Utils.durationTimeParse(state.data.first.timeStart),
          )}'
          ' - '
          '${Utils.durationToClock(
            Utils.durationTimeParse(state.data.first.timeEnd),
          )}',
          style: TextStyle(color: Theme.of(context).primaryColor),
        );
      }
      return TitleText(
        '  -  ',
        style: TextStyle(color: Theme.of(context).primaryColor),
      );
    } else if (state is ScheduleFailure) {
      return InkWell(
        onTap: () {
          BlocProvider.of<ScheduleBloc>(context).add(FetchScheduleEvent(
            DateTime.now(),
            refresh: true,
          ));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh,
              size: Dimens.dp24,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: Dimens.dp4),
            TitleText(
              S.of(context).reload,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      );
    }
    return const Skeleton(
      width: Dimens.dp100,
      height: Dimens.dp16,
    );
  }

  Widget _buildProfileCard() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return UserProfileCard(
            email: state.user?.email ?? '',
            imageUrl: state.user?.image ??
                'https://www.shareicon.net/data/512x512/2016/05/24/770117_people_512x512.png',
            name: state.user?.name ?? '',
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStartBreakeSliderButton() {
    final GlobalKey<SlideActionState> _key = GlobalKey();
    return Container(
        height: 48,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1)),
        child: SlideAction(
          key: _key,
          onSubmit: () {
            widget.onSlideBreakTime?.call();
            Future.delayed(
              const Duration(seconds: 1),
              () => _key.currentState?.reset(),
            );
          },
          innerColor: Theme.of(context).primaryColor,
          outerColor: Colors.white,
          text: S.of(context).start_break,
          borderRadius: 24,
          textStyle:
              TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
          sliderButtonYOffset: -1,
          sliderRotate: false,
          sliderButtonIconPadding: 10,
          height: 24,
          elevation: 0,
          alignment: Alignment.center,
          submittedIcon: const CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          sliderButtonIcon: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
        ));
  }

  Widget _buildFinishBreakeSliderButton() {
    final GlobalKey<SlideActionState> _key = GlobalKey();
    return Container(
      height: Dimens.dp48,
      width: (MediaQuery.of(context).size.width - Dimens.dp36),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Theme.of(context).primaryColor),
      child: SlideAction(
        key: _key,
        onSubmit: () {
          widget.onSlideBreakTime?.call();
          Future.delayed(
            const Duration(seconds: 1),
            () => _key.currentState?.reset(),
          );
        },
        innerColor: Colors.white,
        outerColor: Theme.of(context).primaryColor,
        text: S.of(context).back_to_work,
        borderRadius: 24,
        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
        sliderButtonYOffset: -1,
        sliderRotate: false,
        sliderButtonIconPadding: 10,
        height: 24,
        elevation: 0,
        alignment: Alignment.center,
        submittedIcon: const CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.white,
        ),
        sliderButtonIcon: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xff1B4FAA),
          size: 16,
        ),
      ),
    );
  }

  Widget _buildWarning() {
    return BlocBuilder<ClockButtonTypeBloc, ClockButtonTypeState>(
      builder: (context, state) {
        if (state is ClockButtonTypeSuccess &&
            state.data.messageType != ClockMessageType.none) {
          return Container(
            decoration: BoxDecoration(
              color: StaticColors.yellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Dimens.dp8),
              border: Border.all(color: StaticColors.yellow),
            ),
            margin: const EdgeInsets.only(top: Dimens.dp8),
            padding: const EdgeInsets.all(Dimens.dp8),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubTitle1Text(
                      S
                          .of(context)
                          .warning_home_attendance_without_schedule_title,
                      style: const TextStyle(fontSize: Dimens.dp14),
                    ),
                    const SizedBox(height: Dimens.dp8),
                    Text(
                      state.data.messageType.toWaringMessage(context),
                      style: const TextStyle(fontSize: Dimens.dp12),
                    )
                  ],
                ),
                const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: StaticColors.yellow,
                    size: Dimens.dp16,
                  ),
                )
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildBtnClockIn() {
    return BlocBuilder<ClockButtonTypeBloc, ClockButtonTypeState>(
      builder: (context, state) {
        if (state is ClockButtonTypeSuccess) {
          if (state.data.isAlreadyClockout) {
            return Expanded(
              child: PrimaryButton(
                onPressed: () {},
                color: StaticColors.green,
                child: Text(S.current.resolved_attendance),
              ),
            );
          } else if (state.data.type == ClockButtonType.clockIn) {
            return PrimaryButton(
              onPressed: widget.onTapClockIn,
              color: Theme.of(context).primaryColor,
              child: Text(S.of(context).clock_in),
            );
          } else {
            return IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        if (state.data.breakType == BreakType.end) ...[
                          Expanded(child: _buildFinishBreakeSliderButton()),
                        ] else ...[
                          Expanded(child: _buildStartBreakeSliderButton()),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.dp8),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        if (state.data.messageType ==
                            ClockMessageType.clockOut) ...[
                          Expanded(
                            child: TextButton(
                              onPressed:
                                  _showCancelAttendanceDialogConfirmation,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.dp14,
                                  horizontal: Dimens.dp8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.dp10),
                                ),
                              ),
                              child: Text(
                                S.of(context).cancel_attendance,
                                style: const TextStyle(fontSize: Dimens.dp14),
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimens.dp16),
                        ],
                        Expanded(
                          child: PrimaryButton(
                            onPressed: widget.onTapClockOut,
                            color: StaticColors.red,
                            child: Text(S.of(context).clock_out),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        } else if (state is ClockButtonTypeFailure) {
          return PrimaryButton(
            onPressed: () {
              BlocProvider.of<ClockButtonTypeBloc>(context)
                  .add(const ClockButtonTypeFetched(refresh: true));
            },
            color: Theme.of(context).primaryColor,
            child: Text(S.of(context).reload),
          );
        }

        return const Skeleton(
          height: Dimens.dp50,
          width: double.infinity,
          radius: Dimens.dp8,
        );
      },
    );
  }

  void _showCancelAttendanceDialogConfirmation() {
    showDialog(
        context: context,
        builder: (_) => AppAlertDialog(
              body: Text(S.of(context).cancel_attendance_confirmation_message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<CancelAttendanceBloc>(context)
                        .add(const CancelAttendanceSubmitted());
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).yes),
                ),
              ],
            ));
  }

  // Future<void> scheduleNotification(
  //     DateTime targetTime, String title, String body) async {
  //   final androidDetails = AndroidNotificationDetails(
  //     'your_channel_id',
  //     'Your Channel Name',
  //     channelDescription: 'Notification before schedule',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   final notificationDetails = NotificationDetails(android: androidDetails);

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     targetTime.millisecondsSinceEpoch ~/ 1000, // unique id
  //     title,
  //     body,
  //     tz.TZDateTime.from(targetTime, tz.local),
  //     notificationDetails, androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }
}

extension _ClockMessageTypeX on ClockMessageType {
  String toWaringMessage(BuildContext context) {
    switch (this) {
      case ClockMessageType.clockIn:
        return S
            .of(context)
            .warning_home_attendance_clock_in_without_schedule_subtitle;
      case ClockMessageType.clockOut:
        return S
            .of(context)
            .warning_home_attendance_clock_out_without_schedule_subtitle;
      case ClockMessageType.alreadyAttendance:
        return S
            .of(context)
            .warning_home_attendance_alread_attendance_without_schedule_subtitle;
      default:
        return '';
    }
  }
}
