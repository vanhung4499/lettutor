import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/widgets/not_found_field.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/network/isolate/isolate_run.dart';
import 'package:lettutor/core/widgets/dialog_request.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/core/widgets/pagination_view/default_pagination.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/schedule_bloc.dart';
import '../blocs/schedule_state.dart';
import './widgets/booking_info_item.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  ScheduleBloc get _bloc => BlocProvider.of<ScheduleBloc>(context);

  Color get _backgroundColor => Theme.of(context).scaffoldBackgroundColor;

  Color get _primaryColor => Theme.of(context).primaryColor;

  Object? listen;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    listen ??= _bloc.state$.flatMap(handleState).collect();

    IsolateRunT<bool>(
      data: true,
      progressCall: (event) => log("⌚⌚ [Isolate handler] get schedule $event"),
    ).updateEventCallAndInit(event: () {
      // log("🍜🍜 [Isolate handler] Render isolate in here");
      return true;
    });

    _bloc.getBookingInfo();

    _tabController = TabController(
      animationDuration: const Duration(milliseconds: 300),
      length: 2,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _openEditRequestDialog({required String bookingId}) async {
    final content = await showDialog(
      context: context,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: DialogRequest(),
      ),
    );
    if (content is String && content.isNotEmpty) {
      _bloc.editRequest(bookingId, content);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: _bloc.loading$,
      builder: (ctx, sS) {
        final loading = sS.data ?? false;
        return Stack(
          children: [
            _body(context),
            if (loading)
              Container(
                color: Colors.black45,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _loading(),
              )
          ],
        );
      },
    );
  }

  Scaffold _body(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.school, color: _primaryColor),
            Text(
              ' ${S.of(context).schedule}',
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _bloc.refreshData(),
        child: StreamBuilder(
          stream: _bloc.history$,
          builder: (ctx, sS) {
            final history = sS.data;
            if (history == null) {
              return const NotFoundField();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  tabs: [
                    ...[S.of(context).upComing, S.of(context).history]
                        .map((e) => Tab(text: e, height: 40.0))
                  ],
                  controller: _tabController,
                  onTap: (value) => _bloc.changeTab(value),
                  padding: const EdgeInsets.all(10.0),
                  physics: const BouncingScrollPhysics(),
                  indicatorPadding: const EdgeInsets.all(0.0),
                  isScrollable: true,
                  unselectedLabelStyle: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor,
                  ),
                  unselectedLabelColor: Theme.of(context).hintColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  splashBorderRadius: BorderRadius.circular(5.0),
                  splashFactory: NoSplash.splashFactory,
                  labelColor: Colors.white,
                  labelStyle: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  indicator: BoxDecoration(
                    border: Border.all(width: 1, color: _primaryColor),
                    borderRadius: BorderRadius.circular(5.0),
                    color: _primaryColor,
                  ),
                ),
                StreamBuilder<int>(
                  stream: _bloc.tab$,
                  builder: (ctx1, sS1) {
                    final tab = sS1.data ?? 0;
                    return Expanded(
                      child:
                      _listHBookingInfoField(history: history, currentTab: tab),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _listHBookingInfoField(
      {required Pagination<BookingInfo> history, required int currentTab}) {
    if (history.rows.isEmpty) {
      return const NotFoundField();
    }
    return DefaultPagination(
      items: history.rows,
      loading: false,
      itemBuilder: (_, index) {
        final bookingItem = history.rows[index] as BookingInfo;
        return BookingInfoItem(
          bookingInfo: bookingItem,
          isHistoryType: currentTab == 1,
          cancelFunction: () => _bloc.cancelBookingTutor(bookingItem),
          editRequestFunction: () => _openEditRequestDialog(bookingId: bookingItem.id),
          rattingFunction: () =>
              context.openPageWithRouteAndParams(Routes.ratting, bookingItem.id),
        );
      },
      listenScrollBottom: () => _bloc.getBookingInfo(),
    );
  }

  Center _loading() {
    return Center(
      child: StyleLoadingWidget.foldingCube
          .renderWidget(size: 40.0, color: _primaryColor),
    );
  }

  Stream handleState(state) async* {
    if (state is GetBookingInfoSuccess) {
      log("🌆[Get booking history] success");
      return;
    }
    if (state is GetBookingInfoFailed) {
      log("🌆 ${state.toString()}");
      return;
    }
    if (state is CancelBookingTutorSuccess) {
      log("🌆[Cancel booking tutor] success");
      return;
    }
    if (state is CancelBookingTutorFailed) {
      log("🌆 ${state.toString()}");
    }
    if (state is UpdateStudentRequestSuccess) {
      log("🌆[Update student request] success");
      return;
    }
    if (state is UpdateStudentRequestFailed) {
      log("🌆 ${state.toString()}");
    }
  }
}
