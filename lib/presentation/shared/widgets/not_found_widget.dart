import 'package:flutter/material.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/generated/l10n.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              color: Theme.of(context).primaryColor, size: 30.0),
          const SizedBox(height: 10.0),
          Text(
            S.of(context).resultNotFound,
            style: context.titleMedium.copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
