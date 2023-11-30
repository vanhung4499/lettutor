import 'package:flutter/material.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/utils/handle_time.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/domain/entities/schedule/schedule.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/generated/l10n.dart';

class ScheduleItem extends StatelessWidget {
  final Schedule schedule;
  final Function() onPress;
  const ScheduleItem({
    super.key,
    required this.schedule,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            blurRadius: 10.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRichText(
            header: S.of(context).lessonDate,
            title:
            DateFormat().add_yMMMMEEEEd().format(schedule.startTimestamp),
            context: context,
          ),
          const SizedBox(height: 5),
          _buildRichText(
            header: S.of(context).startTime,
            title: getjmFormat(schedule.startTimestamp),
            context: context,
          ),
          const SizedBox(height: 5),
          _buildRichText(
            header: S.of(context).endTime,
            title: getjmFormat(schedule.endTimestamp),
            context: context,
          ),
          const SizedBox(height: 5),
          ButtonCustom(
            onPress: onPress,
            radius: 10.0,
            height: 35.0,
            child: Text(
              S.of(context).bookTutor,
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ].expand((e) => [e, const SizedBox(height: 2.0)]).toList()
          ..removeLast(),
      ),
    );
  }

  Widget _buildRichText(
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
