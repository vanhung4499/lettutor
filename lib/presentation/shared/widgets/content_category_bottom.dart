
import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/presentation/ebook/blocs/ebook_bloc.dart';

import '../../home/blocs/home_bloc.dart';

class CourseCategoryBottom extends StatefulWidget {
  const CourseCategoryBottom({
    super.key,
    this.bloc,
    this.ebookBloc,
  }) : assert(
  (bloc != null && ebookBloc == null) || (bloc == null && ebookBloc != null),
  "Error",
  );

  final HomeBloc? bloc;
  final EbookBloc? ebookBloc;

  @override
  State<CourseCategoryBottom> createState() => _CourseCategoryBottomState();
}

class _CourseCategoryBottomState extends State<CourseCategoryBottom> {
  @override
  void initState() {
    super.initState();
    if (widget.bloc != null) {
      widget.bloc?.listCourseCategory();
    }
    if (widget.ebookBloc != null) {
      widget.ebookBloc?.listCourseCategory();
    }
  }

  ValueNotifier<String> categorySelected = ValueNotifier<String>("");

  Color get _primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.widthDevice,
      constraints: BoxConstraints(
        maxHeight: context.heightDevice * 0.35,
        minHeight: context.heightDevice * 0.3,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonCustom(
            height: 45.0,
            radius: 5.0,
            onPress: () => context.popArgs(categorySelected.value),
            child: Text(
              'Apply',
              style: context.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: widget.bloc?.courseCategories$ ??
                widget.ebookBloc?.courseCategories$,
            builder: (ctx, sS) {
              final data = sS.data ?? [];
              return ValueListenableBuilder(
                valueListenable: categorySelected,
                builder: (ctx, category, text) {
                  return Wrap(
                    spacing: 6.0,
                    runSpacing: -8,
                    alignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      ...data.map((e) {
                        final isSelected = e.id == category;
                        return ChoiceChip(
                          label: Text(
                            e.title,
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
                              ? Icon(Icons.check,
                              color: _primaryColor, size: 15.0)
                              : null,
                          selected: isSelected,
                          onSelected: (_) {
                            categorySelected.value = e.id;
                          },
                          backgroundColor:
                          Theme.of(context).dividerColor.withOpacity(0.07),
                          selectedColor: _primaryColor.withOpacity(0.1),
                        );
                      })
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
