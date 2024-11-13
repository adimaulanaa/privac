import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';

void showSnackBarAndNavigate(BuildContext context, String message,
    SnackBarStatus status, Duration duration, VoidCallback onNavigate) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              message,
              style: whiteTextstyle.copyWith(
                fontSize: 11,
                fontWeight: semiMedium,
              ),
            ),
          ),
          10.horizontalSpace,
          InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              scaffoldMessenger.hideCurrentSnackBar();
            },
            child: Text(
              'Close',
              style: whiteTextstyle.copyWith(
                fontSize: 11,
                fontWeight: semiMedium,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getSnackBarColor(status),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
      // action: SnackBarAction(
      //   label: 'Close',
      //   textColor: Colors.white,
      //   onPressed: () {
      //     scaffoldMessenger.hideCurrentSnackBar();
      //   },
      // ),
    ),
  );

  Future.delayed(duration, () {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      onNavigate();
    });
  });
}

Color _getSnackBarColor(SnackBarStatus status) {
  switch (status) {
    case SnackBarStatus.success:
      return Colors.green;
    case SnackBarStatus.error:
      return Colors.red;
    case SnackBarStatus.info:
      return Colors.yellow;
    default:
      return Colors.black;
  }
}

enum SnackBarStatus { success, error, info }