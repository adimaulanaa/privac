import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privac/core/uikit/src/assets/media_res.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';

class IconBackAppbar extends StatelessWidget {
  final VoidCallback? onTap;

  const IconBackAppbar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        // width: 50,
        // height: 50,
        margin: const EdgeInsets.only(left: 15, top: 5),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.bgColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          MediaRes.back,
          // ignore: deprecated_member_use
          color: AppColors.bgBlack,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class IconSaveAppbar extends StatelessWidget {
  final VoidCallback? onTap;

  const IconSaveAppbar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      // borderRadius: BorderRadius.circular(20), // Sesuaikan dengan bentuk lingkaran
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 15, top: 5),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.bgColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          MediaRes.checklist,
          // ignore: deprecated_member_use
          color: AppColors.bgBlack,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class IconDots extends StatelessWidget {
  final VoidCallback? onTap;

  const IconDots({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(20), // Sesuaikan dengan bentuk lingkaran
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 15, top: 5),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.bgColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          MediaRes.vertical,
          // ignore: deprecated_member_use
          color: AppColors.bgBlack,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
