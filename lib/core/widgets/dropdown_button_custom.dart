import 'package:flutter/material.dart';
import 'package:lettutor/core/extensions/context_extension.dart';

class DropdownButtonCustom<T> extends StatelessWidget {
  final double? width;
  final double? borderWidth;
  final double? height;
  final double? radius;
  final bool showIcon;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final Function(T?) onChange;
  final String? headerText;

  const DropdownButtonCustom({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.color,
    this.padding,
    this.borderColor,
    this.borderWidth,
    this.headerText,
    this.showIcon = true,
    required this.items,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius ?? 15.0),
        border: Border.all(
          width: borderWidth ?? 1,
          color: borderColor ?? Theme.of(context).dividerColor,
        ),
      ),
      child: DropdownButtonFormField<T>(
        borderRadius: BorderRadius.circular(10),

        decoration: InputDecoration(
          labelText: headerText,
          labelStyle: context.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        focusColor: Theme.of(context).primaryColor,
        icon: Visibility (visible:showIcon, child: const Icon(Icons.arrow_drop_down)),
        padding: const EdgeInsets.all(0.0),
        items: items,
        onChanged: onChange,
        value: value,
      ),
    );
  }
}
