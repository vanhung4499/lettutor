import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/extensions/context_extension.dart';

import 'button_custom.dart';


class DialogRequest extends StatefulWidget {
  const DialogRequest({
    super.key,
  });

  @override
  State<DialogRequest> createState() =>
      _DialogRequestState();
}

class _DialogRequestState
    extends State<DialogRequest> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.heightDevice * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update request student',
                    style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('Enter your note here', style: context.titleMedium),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: "Add note",
                    ),
                  ),
                ].expand((e) => [e, const SizedBox(height: 5.0)]).toList()
                  ..removeLast(),
              )),
          ButtonCustom(
            radius: 5.0,
            onPress: () => context.popArgs(_noteController.text),
            child: Text(
              'Update',
              style: context.titleSmall
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
