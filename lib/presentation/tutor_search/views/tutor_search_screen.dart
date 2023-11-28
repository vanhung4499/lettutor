import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/data/models/request/tutor_nationality.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/core/widgets/header_custom.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/tutor_search_bloc.dart';
import '../blocs/tutor_search_state.dart';

class TutorSearchScreen extends StatefulWidget {
  const TutorSearchScreen({super.key});

  @override
  State<TutorSearchScreen> createState() => TutorSearchScreenState();
}

class TutorSearchScreenState extends State<TutorSearchScreen> {
  Object? listen;

  final TextEditingController _searchController = TextEditingController();

  TutorSearchBloc get _bloc => BlocProvider.of<TutorSearchBloc>(context);

  Color get _primaryColor => Theme.of(context).primaryColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    listen ??= _bloc.state$.flatMap(handleState).collect();
    _bloc.listTopic();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: context.titleLarge.color),
        ),
        title: Text(
          S.of(context).tutorSearch,
          style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.of(context).searchHere,
              ),
            ),
          ),
          HeaderTextCustom(headerText: S.of(context).nationality),
          _nationalityTutorsField(context),
          HeaderTextCustom(headerText: S.of(context).topics),
          StreamBuilder<bool?>(
            stream: _bloc.loading$,
            builder: (ctx1, sS1) {
              final loading = sS1.data ?? false;
              if (loading) {
                return Center(
                  child: StyleLoadingWidget.foldingCube
                      .renderWidget(size: 40.0, color: _primaryColor),
                );
              }
              return StreamBuilder<List<Topic>>(
                stream: _bloc.topics$,
                builder: (ctx2, sS2) {
                  final topics = sS2.data ?? <Topic>[];
                  return StreamBuilder<List<Topic>>(
                    stream: _bloc.selectedTopic$,
                    builder: (ctx3, sS3) {
                      final topicSelected = sS3.data ?? <Topic>[];
                      return _topicsField(
                        topics: topics,
                        topicsSelected: topicSelected,
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ButtonCustom(
              onPress: () => _bloc.openSearchResultPage(_searchController.text),
              radius: 5.0,
              child: Text(
                S.of(context).search,
                style: context.titleMedium
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          )
        ].expand((e) => [e, const SizedBox(height: 5.0)]).toList(),
      ),
    );
  }

  StreamBuilder<TutorNationality> _nationalityTutorsField(
      BuildContext context) {
    return StreamBuilder<TutorNationality>(
      stream: _bloc.tutorNationality,
      builder: (ctx, sS) {
        return Column(
          children: [
            ...nationalityConstants.map(
                  (e) => ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                title: Text(e.name, style: context.titleMedium),
                leading: Radio<TutorNationality>(
                  activeColor: _primaryColor,
                  value: e,
                  onChanged: (TutorNationality? nationalityTutor) =>
                      _bloc.selectedTutorNationality(
                          nationalityTutor ?? nationalityConstants.first),
                  groupValue: sS.data,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Padding _topicsField(
      {required List<Topic> topics, required List<Topic> topicsSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Wrap(
        spacing: 6.0,
        runSpacing: -8,
        alignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.up,
        children: [
          ...topics.map((e) {
            final isSelected = topicsSelected.contains(e);
            return ChoiceChip(
              label: Text(
                e.name ?? '',
                style: context.titleSmall.copyWith(
                  fontSize: 14,
                  color: isSelected ? _primaryColor : null,
                  fontWeight: FontWeight.w400,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              avatar: isSelected
                  ? Icon(Icons.check, color: _primaryColor, size: 15.0)
                  : null,
              selected: isSelected,
              onSelected: (_) => _bloc.selectedTopic(e),
              backgroundColor: Theme.of(context).dividerColor.withOpacity(0.07),
              selectedColor: _primaryColor.withOpacity(0.1),
            );
          })
        ],
      ),
    );
  }

  Stream handleState(state) async* {
    if (state is ListTopicFailed) {
      log("🐼 [List topic] failed");
      return;
    }
    if (state is ListTopicSuccess) {
      log("🐼 [List topic] success");
      return;
    }
    if (state is OpenSearchTutorResultPageSuccess) {
      log("🐼 [Open search tutor result page] ${state.searchTutorRequest.toString()}");
      context.openPageWithRouteAndParams(
          Routes.tutorSearch, state.searchTutorRequest);
      return;
    }
  }
}
