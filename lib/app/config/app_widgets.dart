import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/config/app_constants.dart';

final InputDecoration searchTextfieldDecoration = InputDecoration(
  hintText: AppConstants.search.tr,
  contentPadding: const EdgeInsets.fromLTRB(5, 2, 10, 2),
  fillColor: Colors.grey.shade200,
  filled: true,
  isDense: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10.0),
  ),
  prefixIcon: const Icon(
    Icons.search,
    color: AppColors.grey,
    size: 20,
  ),
);
