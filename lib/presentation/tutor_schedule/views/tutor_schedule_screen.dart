import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/utils/handle_time.dart';
import 'package:lettutor/domain/entities/schedule/schedule_detail.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/presentation/shared/widgets/add_booking_note.dart';
import 'package:lettutor/presentation/shared/widgets/not_found_widget.dart';
import 'package:lettutor/presentation/shared/widgets/schedule_item.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/core/widgets/range_date_picker_custom.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/domain/entities/schedule/schedule.dart';

import '../blocs/tutor_schedule_bloc.dart';
import '../blocs/tutor_schedule_state.dart';

class TutorScheduleScreen extends StatefulWidget {
  const TutorScheduleScreen({super.key});

  @override
  State<TutorScheduleScreen> createState() => _TutorScheduleScreenState();
}

class _TutorScheduleScreenState extends State<TutorScheduleScreen> {
  TutorScheduleBloc get _bloc => BlocProvider.of<TutorScheduleBloc>(context);

  Object? listen;

  Color get _backgroundColor => Theme.of(context).scaffoldBackgroundColor;

  Color get _primaryColor => Theme.of(context).primaryColor;

  final RangeDateController _rangeDateController = RangeDateController();

  @override
  void initState() {
    super.initState();
    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.getTutorSchedule();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _openSelectTimeWidget() async {
    final result = await context.pickRangeDate(_rangeDateController);
    if (result?.isNotEmpty ?? false) {
      _bloc.selectTime(result!.first, result.last);
    }
  }

  void _buildBookingDialog({required ScheduleDetail schedule}) async {
    final addNote = await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: BookingNoteWidget(scheduleDetail: schedule),
      ),
    );
    if (addNote is String && addNote.isNotEmpty) {
      if (schedule.id.isNotEmpty) {
        log("[schedule id] ${schedule.id}\n[note] $addNote");
        _bloc.bookTutorClass(schedule.id, addNote);
      }
    }
  }

  @override
  void dispose() {
    _rangeDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: _bloc.loadingTutorClass$,
      builder: (ctx, sS) {
        final loading = sS.data ?? false;
        return Stack(
          children: [
            _buildBody(context),
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

  Scaffold _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: context.titleLarge.color),
        ),
        title: Text(
          S.of(context).tutorSchedule,
          style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<Map<String, DateTime>>(
            stream: Rx.combineLatest2(_bloc.startTime$, _bloc.endTime$,
                    (sT, eT) => {'sT': sT, 'eT': eT}),
            builder: (ctx, sS) {
              final sT = sS.data?['sT'] ??
                  DateTime.now().subtract(const Duration(days: 1));
              final eT =
                  sS.data?['eT'] ?? DateTime.now().add(const Duration(days: 5));
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${S.of(context).pickTime}: ',
                      style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600)),
                  TextButton(
                    onPressed: _openSelectTimeWidget,
                    child: Text(
                      '${getYmdFormat(sT)} - ${getYmdFormat(eT)}',
                      style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600, color: _primaryColor),
                    ),
                  )
                ],
              );
            },
          ),
          StreamBuilder<bool?>(
            stream: _bloc.loading$,
            builder: (ctx, sS) {
              final loading = sS.data ?? false;
              if (loading) {
                return Expanded(child: _loading());
              }
              return StreamBuilder<List<Schedule>>(
                stream: _bloc.schedule$,
                builder: (ctx1, sS1) {
                  final data = sS1.data ?? <Schedule>[];
                  if (data.isEmpty) {
                    return const Expanded(child: NotFoundWidget());
                  }
                  return _buildScheduleListView(data);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Expanded _buildScheduleListView(List<Schedule> data) {
    return Expanded(
      child: ListView(
        children: [
          ...data.map(
                (e) => ScheduleItem(
              schedule: e,
              onPress: () {
                if (e.scheduleDetails.isEmpty) {
                  return;
                }
                _buildBookingDialog(schedule: e.scheduleDetails.first);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: StyleLoadingWidget.fadingCube
          .renderWidget(size: 40.0, color: _primaryColor),
    );
  }

  Stream handleState(state) async* {
    if (state is GetTutorScheduleSuccess) {
      log("🌟[Get tutor schedule] success");
      return;
    }
    if (state is GetTutorScheduleFailed) {
      log("🌟 ${state.toString()}");
      return;
    }
    if (state is BooTutorClassSuccess) {
      log("🌟 [Boo tutor] success");
      return;
    }
    if (state is BooTutorClassFailed) {
      log("🌟 ${state.toString()}");
      return;
    }
  }
}
