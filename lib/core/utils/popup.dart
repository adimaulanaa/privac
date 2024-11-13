// lib/utils/utils.dart

import 'package:flutter/material.dart';
import 'package:privac/core/utils/navigation_helper.dart';

// Function to show error popup with dynamic callback
void errorPopup(BuildContext context, String error, Function callback) {
  showSnackBarAndNavigate(
    context,
    error,
    SnackBarStatus.error,
    const Duration(milliseconds: 2500),
    () {
      callback();  // Execute the dynamic callback
    },
  );
}

// Function to show success popup with dynamic callback
void succesPopup(BuildContext context, String suc, Function callback) {
  return showSnackBarAndNavigate(
    context,
    suc,
    SnackBarStatus.success,
    const Duration(milliseconds: 2500),
    () {
      callback();  // Execute the dynamic callback
    },
  );
}
