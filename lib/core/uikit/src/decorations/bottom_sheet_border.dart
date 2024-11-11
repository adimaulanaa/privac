import 'package:flutter/material.dart';

class UIBottomSheetBorder extends RoundedRectangleBorder {
  const UIBottomSheetBorder()
      : super(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        );
}
