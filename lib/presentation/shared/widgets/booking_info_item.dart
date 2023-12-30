import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';
import 'package:lettutor/core/utils/handle_time.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/core/widgets/tutor_info_hero.dart';
import 'package:lettutor/generated/l10n.dart';

class BookingInfoItem extends StatelessWidget {
  const BookingInfoItem({
    super.key,
    required this.bookingInfo,
    required this.isHistoryType,
    this.cancelFunction,
    this.editRequestFunction,
    this.rattingFunction,
  });

  final BookingInfo bookingInfo;
  final bool isHistoryType;
  final Function()? cancelFunction;
  final Function()? editRequestFunction;
  final Function()? rattingFunction;

  @override
  Widget build(BuildContext context) {
    final tutorInfo = bookingInfo.scheduleDetailInfo?.scheduleInfo?.tutorInfo;
    if (tutorInfo == null) {
      return const SizedBox();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.3),
            blurRadius: 5.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TutorInfoHero(
              tutor: tutorInfo, showFavorite: false, showRatting: false),
          ...[
            bookingInfo.scheduleDetailInfo?.startPeriodTimestamp,
            bookingInfo.scheduleDetailInfo?.startPeriodTimestamp,
            bookingInfo.scheduleDetailInfo?.endPeriodTimestamp,
          ].mapIndexed((index, e) {
            if (e == null) {
              return const SizedBox();
            }
            return _buildRichText(
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
          if (isHistoryType)
            _buildHistoryButton(context)
          else
            _buildUpcomingButton(context),
        ].expand((e) => [e, const SizedBox(height: 5.0)]).toList()
          ..removeLast(),
      ),
    );
  }

  Widget _buildUpcomingButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ButtonCustom(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderColor: Colors.red,
          height: 40.0,
          radius: 10.0,
          onPress: cancelFunction ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.close, color: Colors.red),
              Text(
                S.of(context).cancel,
                style: context.titleMedium
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
              )
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1, color: Theme.of(context).dividerColor),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5.0),
                  ),
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        S.of(context).lessonRequest,
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: ButtonCustom(
                        height: 35.0,
                        radius: 5.0,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderColor: Theme.of(context).primaryColor,
                        onPress: editRequestFunction ?? () {},
                        child: Text(
                            S.of(context).edit,
                            style: context.titleSmall
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  bookingInfo.studentRequest ?? S.of(context).noRequest,
                  style:
                  context.titleMedium.copyWith(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Row _buildHistoryButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: ButtonCustom(
            onPress: rattingFunction ?? () {},
            height: 40.0,
            radius: 5.0,
            child: Text(
              S.of(context).rating,
              style: context.titleMedium
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          flex: 2,
          child: ButtonCustom(
            onPress:  () {},
            borderColor: Colors.redAccent,
            width: double.infinity,
            height: 40.0,
            radius: 5.0,
            color: Theme.of(context).cardColor,
            child: const Icon(
              Icons.warning,
              color: Colors.redAccent,
              size: 20.0,
            ),
          ),
        )
      ],
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
