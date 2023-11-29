import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/utils/state_mixins/did_change_dependencies_mixin.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/presentation/shared/widgets/content_category_bottom.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/home_bloc.dart';
import '../blocs/home_state.dart';
import '../../shared/widgets/course_card.dart';
import '../../shared/widgets/row_search_field.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> with DidChangeDependencies {
  CourseListBloc get _bloc => BlocProvider.of<CourseListBloc>(context);

  Color get _primaryColor => Theme.of(context).primaryColor;

  ScrollController? _scrollController;

  Object? listen;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_listenerScroll);
  }

  void _listenerScroll() {
    if (_scrollController!.position.atEdge) {
      if (_scrollController!.position.pixels != 0) {
        _bloc.fetchData();
      }
    }
  }

  void _openSelectedFilter() async {
    final getCategories = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return CourseCategoryBottom(bloc: _bloc);
        // return const SizedBox();
      },
    );
    if (getCategories is String) {
      _bloc.applyCategory(getCategories);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_scrollController != null) {
      _scrollController!.removeListener(_listenerScroll);
      _scrollController!.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.fetchData();
    // dom something
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.school, color: _primaryColor),
            Text(
              ' ${S.of(context).courses}',
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: Column(
        children: [
          RowSearchField(
              onSubmit: (text) => _bloc.submitWithText(text),
              openSelectedFilter: _openSelectedFilter),
          Expanded(
            child: StreamBuilder(
              stream: _bloc.courses$,
              builder: (ctx1, snapShot) {
                final listItem = snapShot.data?.rows ?? <Course>[];
                return StreamBuilder(
                  stream: _bloc.loading$,
                  builder: (ctx2, snapShot2) {
                    return RefreshIndicator(
                      onRefresh: () async => _bloc.onRefreshData(),
                      child: _listView(
                        listItem: listItem,
                        loading: snapShot2.data ?? false,
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _listView({required List<dynamic> listItem, required bool loading}) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      controller: _scrollController,
      itemCount: listItem.length + 1,
      itemBuilder: (context, index) {
        if (index < listItem.length) {
          return CourseCard(course: listItem[index]);
        }
        if (index >= listItem.length && (loading)) {
          Timer(const Duration(milliseconds: 30), () {
            _scrollController!.jumpTo(
              _scrollController!.position.maxScrollExtent,
            );
          });
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: StyleLoadingWidget.fadingCube.renderWidget(
                  size: 40.0, color: Theme.of(context).primaryColor),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Stream<void> handleState(state) async* {
    if (state is FetchDataCourseFailed) {
      log('[Fetch data course] ${state.message}');
      return;
    }
    if (state is FetchDataCourseSuccess) {
      log('[Fetch data success] ${state.message}');
      return;
    }
  }
}
