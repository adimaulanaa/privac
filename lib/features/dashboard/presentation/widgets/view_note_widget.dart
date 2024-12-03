import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';

// ignore: must_be_immutable
class IconRowMenu extends StatelessWidget {
  Size size;
  String text;
  String img;
  IconRowMenu({
    super.key,
    required this.size,
    required this.text,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.25,
      height: size.height * 0.11,
      decoration: BoxDecoration(
        color: AppColors.bgGreySecond,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            img.toString(),
            width: 30,
            // ignore: deprecated_member_use
            color: AppColors.bgBlack,
            fit: BoxFit.cover,
          ),
          10.verticalSpace,
          Text(
            text.toString(),
            style: blackTextstyle.copyWith(
              fontSize: 14,
              fontWeight: light,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ViewSVG extends StatelessWidget {
  String img;
  Color colors;
  ViewSVG({
    super.key,
    required this.img,
    this.colors = AppColors.bgBlack,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      img,
      width: 18,
      // ignore: deprecated_member_use
      color: colors,
      fit: BoxFit.cover,
    );
  }
}

// ignore: must_be_immutable
class ViewListOther extends StatelessWidget {
  String text;
  String img;
  Color colors;
  ViewListOther({
    super.key,
    required this.text,
    required this.img,
    this.colors = AppColors.bgBlack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          ViewSVG(img: img, colors: colors),
          10.horizontalSpace,
          Text(
            text,
            style: transTextstyle.copyWith(
              fontSize: 13,
              fontWeight: light,
              color: colors,
            ),
          ),
        ],
      ),
    );
  }
}

Divider dividers() {
  return const Divider(
    color: AppColors.bgGreySecond, // Warna garis
    thickness: 1.5, // Ketebalan garis
  );
}

SvgPicture viewSvg(String img) {
  return SvgPicture.asset(
    img,
    // ignore: deprecated_member_use
    color: AppColors.bgBlack,
    fit: BoxFit.cover,
  );
}
