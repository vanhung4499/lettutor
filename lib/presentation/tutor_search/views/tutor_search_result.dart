import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/pagination_view/default_pagination.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/presentation/shared/widgets/not_found_field.dart';
import 'package:lettutor/presentation/shared/widgets/tutor_card_view.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/tutor_search_result_bloc.dart';
import '../blocs/tutor_search_result_state.dart';

class TutorSearchResultView extends StatefulWidget {
  const TutorSearchResultView({super.key});

  @override
  State<TutorSearchResultView> createState() => _TutorSearchResultViewState();
}

class _TutorSearchResultViewState extends State<TutorSearchResultView> {
  TutorSearchResultBloc get _bloc =>
      BlocProvider.of<TutorSearchResultBloc>(context);

  Object? listen;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.searchTutor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: Theme.of(context).shadowColor),
        ),
        title: Text(
          S.of(context).searchTutorResult,
          style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: StreamBuilder(
              stream: _bloc.tutor$,
              builder: (ctx1, sS1) {
                final listItem = sS1.data?.tutors.rows ?? <Tutor>[];
                log("🌟 [Data length] ${listItem.length}");
                return StreamBuilder<bool?>(
                    stream: _bloc.loading$,
                    builder: (ctx2, sS2) {
                      final loading = sS2.data ?? false;
                      if (!loading && listItem.isEmpty) {
                        return const NotFoundField();
                      }
                      return DefaultPagination(
                        items: listItem,
                        loading: loading,
                        itemBuilder: (_, index) {
                          final tutor = listItem[index];
                          return TutorCardView(
                            tutor: tutor,
                            isLiked: true,
                            tutorOnPress: () =>
                                context.openPageWithRouteAndParams(
                                    Routes.tutorDetail, tutor.userId),
                            favOnPress: () {
                              // if (tutor.userId != null) {
                              //   _bloc.addTutorToFav(tutor.userId ?? '');
                              // }
                            },
                          );
                        },
                        listenScrollBottom: _bloc.searchTutor,
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }

  Stream handleState(state) async* {
    if (state is TutorSearchSuccess) {
      log("🌟 [Search tutor] Success");
      return;
    }
    if (state is TutorSearchFailed) {
      log("🌟 [Search tutor] Failed message ${state.message}");
      return;
    }
  }
}
