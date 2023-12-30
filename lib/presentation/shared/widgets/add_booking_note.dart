import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/domain/entities/schedule/schedule_detail.dart';
import 'package:lettutor/core/utils/handle_time.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/generated/l10n.dart';

class BookingNoteWidget extends StatefulWidget {
  final ScheduleDetail scheduleDetail;
  const BookingNoteWidget({
    super.key,
    required this.scheduleDetail,
  });

  @override
  State<BookingNoteWidget> createState() => _BookingNoteWidgetState();
}

class _BookingNoteWidgetState extends State<BookingNoteWidget> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final elementBoxStyle = context.titleSmall
        .copyWith(color: primaryColor, fontWeight: FontWeight.w600);
    return Container(
      width: double.infinity,
      height: context.heightDevice * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).bookingDetail,
                  style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: primaryColor.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getjmFormat(widget.scheduleDetail.startPeriodTimestamp)} - ${getjmFormat(widget.scheduleDetail.endPeriodTimestamp)}',
                        style: elementBoxStyle,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        DateFormat()
                            .add_yMMMMEEEEd()
                            .format(widget.scheduleDetail.startPeriodTimestamp),
                        style: elementBoxStyle,
                      ),
                    ],
                  ),
                ),
                Text(S.of(context).notes, style: context.titleMedium),
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    hintText: S.of(context).enterNote,
                  ),
                ),
              ].expand((e) => [e, const SizedBox(height: 5.0)]).toList()
                ..removeLast(),
            )),
        ButtonCustom(
          radius: 10.0,
          onPress: () => context.popArgs(_noteController.text),
          child: Text(
            'Book',
            style: context.titleSmall
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ]),
    );
  }
}
