import 'package:flutter/material.dart';
import 'package:lettutor/generated/l10n.dart';

class RowSearchWidget extends StatelessWidget {
  final Function(String) onSubmit;
  final Function() openSelectedFilter;
  const RowSearchWidget(
      {super.key, required this.onSubmit, required this.openSelectedFilter});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      border: Border.all(width: 1, color: Theme.of(context).hintColor),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: boxDecoration,
              child: TextField(
                onSubmitted: onSubmit,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '${S.of(context).searchHere}...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          GestureDetector(
            onTap: openSelectedFilter,
            child: Container(
              width: 51,
              height: 51,
              decoration: boxDecoration,
              child: Icon(Icons.filter_list, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
