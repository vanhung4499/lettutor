import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/constants/constants.dart';
import 'package:lettutor/core/utils/handle_time.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/core/widgets/tutor_info_hero.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:intl/intl.dart';

import 'package:timer_count_down/timer_count_down.dart';

class MeetingPrepareScreen extends StatefulWidget {
  final BookingInfo bookingInfo;
  const MeetingPrepareScreen({super.key, required this.bookingInfo});

  @override
  State<MeetingPrepareScreen> createState() => _MeetingPrepareScreenState();
}

class _MeetingPrepareScreenState extends State<MeetingPrepareScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTime = Constants.currentTimeMilliSeconds;
    final referenceTime = widget.bookingInfo.scheduleDetailInfo!
        .startPeriodTimestamp.millisecondsSinceEpoch /
        1000;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).meetingPrepare, textAlign: TextAlign.center,),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _meetingInformation(context),
          Countdown(
            seconds: (referenceTime - currentTime).round(),
            build: (BuildContext context, double time) {
              int hours = time.round() ~/ 3600;
              int minutes = (time.round() % 3600) ~/ 60;
              int seconds = time.round() % 60;
              return _buildRichText(hours, minutes, seconds,
                  header: '${S.of(context).upComingLesson} ');
            },
            interval: const Duration(milliseconds: 100),
            onFinished: () {
              context.openPageWithRouteAndParams(
                  Routes.meeting, widget.bookingInfo.studentMeetingLink);
              // _bloc.getUpComingClass();
            },
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ButtonCustom(
              onPress: () {
                context.openPageWithRouteAndParams(
                    Routes.meeting, widget.bookingInfo.studentMeetingLink);
              },
              child: Text(
                  S.of(context).test,
                  style: context.titleMedium.copyWith(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Container _meetingInformation(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColor.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TutorInfoHero(
            tutor: widget.bookingInfo.scheduleDetailInfo!.scheduleInfo!.tutorInfo,
            showFavorite: false,
            showRatting: false,
          ),
          ...[
            widget.bookingInfo.scheduleDetailInfo?.startPeriodTimestamp,
            widget.bookingInfo.scheduleDetailInfo?.startPeriodTimestamp,
            widget.bookingInfo.scheduleDetailInfo?.endPeriodTimestamp,
          ].mapIndexed((index, e) {
            if (e == null) {
              return const SizedBox();
            }
            return _richText(
              header: switch (index) {
                0 => S.of(context).lessonDate,
                1 => S.of(context).startTime,
                _ => S.of(context).endTime
              },
              title: switch (index) {
                0 => DateFormat().add_yMMMMEEEEd().format(e),
                _ => getjmFormat(e)
              },
              context: context,
            );
          }),
        ],
      ),
    );
  }

  RichText _buildRichText(int hours, int minutes, int? seconds,
      {required String header}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: context.titleMedium,
        children: [
          ...[
            header,
            hours.toString(),
            ' ${S.of(context).hours} ',
            minutes.toString(),
            ' ${S.of(context).minutes} ',
            if (seconds != null) ...[seconds.toString(), ' ${S.of(context).seconds}.'],
          ].mapIndexed((index, element) {
            final textStyle = TextStyle(
              fontWeight: index % 2 == 0 ? FontWeight.w400 : FontWeight.w600,
            );
            return TextSpan(text: element, style: textStyle);
          }),
        ],
      ),
    );
  }

  Widget _richText(
      {required String header,
        required String title,
        required BuildContext context}) {
    return RichText(
        text: TextSpan(
          style: context.titleMedium,
          children: [
            TextSpan(
              text: header,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ': $title')
          ],
        ));
  }
}
