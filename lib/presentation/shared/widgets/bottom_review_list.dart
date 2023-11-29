import 'package:flutter/material.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/tutor/review.dart';
import 'package:lettutor/presentation/tutor_detail/blocs/tutor_detail_bloc.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/core/widgets/header_custom.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/generated/l10n.dart';

import 'review_item.dart';

class BottomReviewList extends StatefulWidget {
  final TutorDetailBloc tutorDetailBloc;
  const BottomReviewList({
    super.key,
    required this.tutorDetailBloc,
  });

  @override
  State<BottomReviewList> createState() => _BottomReviewListState();
}

class _BottomReviewListState extends State<BottomReviewList> {
  Color get _primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.widthDevice,
      constraints: BoxConstraints(
        maxHeight: context.heightDevice * 0.8,
        minHeight: context.heightDevice * 0.6,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ButtonCustom(
              height: 45.0,
              radius: 5.0,
              onPress: () {},
              child: Text(
                'Add reviews',
                style: context.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<bool?>(
            stream: widget.tutorDetailBloc.loadingReview$,
            builder: (ctx, sS) {
              final loading = sS.data ?? false;
              return StreamBuilder<Pagination<Review>>(
                stream: widget.tutorDetailBloc.reviews$,
                builder: (ctx1, sS1) {
                  final listReview = sS1.data;
                  final rows = listReview?.rows ?? List.empty();
                  return _viewField(context, listReview, rows, loading);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  ListView _viewField(BuildContext context, Pagination<Review>? listReview,
      List<dynamic> rows, bool loading) {
    return ListView(
      children: [
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 3.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).hintColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        const HeaderTextCustom(
          headerText: 'All reviews',
          padding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        const SizedBox(height: 20.0),
        if (listReview != null) ...rows.map((e) => ReviewItem(review: e)),
        if (loading) _loading(),
        TextButton(
          onPressed: () => widget.tutorDetailBloc.listReview(),
          child: Text(
            S.of(context).seeMore,
            style: context.titleSmall.copyWith(
              color: _primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Center _loading() {
    return Center(
      child: StyleLoadingWidget.fadingCube
          .renderWidget(size: 40.0, color: _primaryColor),
    );
  }
}
