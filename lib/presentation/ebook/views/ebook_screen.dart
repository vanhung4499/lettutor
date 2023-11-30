import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/presentation/shared/widgets/not_found_widget.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/presentation/ebook/blocs/ebook_bloc.dart';
import 'package:lettutor/presentation/ebook/blocs/ebook_state.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/core/widgets/pagination_view/default_pagination.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:lettutor/presentation/shared/widgets/content_category_bottom.dart';
import 'package:lettutor/presentation/shared/widgets/row_search_field.dart';
import 'package:lettutor/presentation/shared/widgets/ebook_card.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class EbookScreen extends StatefulWidget {
  const EbookScreen({super.key});

  @override
  State<EbookScreen> createState() => _EbookScreenState();
}

class _EbookScreenState extends State<EbookScreen> {
  EbookBloc get _bloc => BlocProvider.of<EbookBloc>(context);

  Object? listen;

  Color get _primaryColor => Theme.of(context).primaryColor;

  Color get _backGroundColor => Theme.of(context).scaffoldBackgroundColor;

  @override
  void initState() {
    super.initState();
    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.listEbook(null, null);
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
        return CourseCategoryBottomSheet(ebookBloc: _bloc);
        // return const SizedBox();
      },
    );
    if (getCategories is String) {
      _bloc.listEbook(null, getCategories);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: _bloc.loading$,
      builder: (ctx, sS) {
        final loading = sS.data ?? false;
        return Stack(
          children: [
            _body(context, loading: loading),
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

  Scaffold _body(BuildContext context, {required bool loading}) {
    return Scaffold(
      backgroundColor: _backGroundColor,
      appBar: AppBar(
        backgroundColor: _backGroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: context.titleLarge.color),
        ),
        title: Text(
          S.of(context).allEbook,
          style: context.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _bloc.refreshData(),
        child: Column(
          children: [
            RowSearchWidget(
              onSubmit: (text) => _bloc.listEbook(text, null),
              openSelectedFilter: _openSelectedFilter,
            ),
            Expanded(
              child: StreamBuilder<Pagination<Ebook>>(
                stream: _bloc.ebooks$,
                builder: (ctx, sS) {
                  final listEbook =
                      sS.data?.rows ?? List<Ebook>.empty(growable: true);
                  if (listEbook.isEmpty && !loading) {
                    return const NotFoundWidget();
                  }
                  return DefaultPagination(
                    items: listEbook,
                    loading: false,
                    itemBuilder: (_, index) => EbookCard(ebook: listEbook[index]),
                    listenScrollBottom: () => _bloc.listEbook(null, null),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _loading() {
    return Center(
      child: StyleLoadingWidget.fadingCube
          .renderWidget(size: 40.0, color: _primaryColor),
    );
  }

  Stream handleState(state) async* {
    if (state is GetEbookSuccess) {
      log("🌟[Get E boo] success");
      return;
    }
    if (state is GetEbookFailed) {
      log("🌟${state.toString()}");
      return;
    }
  }
}
