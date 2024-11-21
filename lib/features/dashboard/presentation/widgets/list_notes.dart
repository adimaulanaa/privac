import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:privac/core/uikit/src/assets/media_res.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';

class ListNotes extends StatelessWidget {
  final Size size;
  final NotesModel dt;
  const ListNotes({
    super.key,
    required this.size,
    required this.dt,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy').format(dt.updatedOn!);
    return Container(
      width: (size.width - 40) / 2,
      decoration: BoxDecoration(
        color: AppColors.bgScreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        dt.title.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: blackTextstyle.copyWith(
                          fontSize: 12,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        dt.isPin == 1
                            ? Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: SvgPicture.asset(
                                  MediaRes.dPin,
                                  // ignore: deprecated_member_use
                                  color: AppColors.bgBlack,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const SizedBox.shrink(),
                        SvgPicture.asset(
                          MediaRes.vertical,
                          // ignore: deprecated_member_use
                          color: AppColors.bgBlack,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Text(
                  dt.content.toString(),
                  maxLines: 6,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: greyTextstyle.copyWith(
                    fontSize: 11,
                    fontWeight: semiMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                child: Text(
                  formattedDate,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: greyTextstyle.copyWith(
                    fontSize: 12,
                    fontWeight: light,
                  ),
                ),
              )
            ],
          ),
          // Layer transparan dengan ikon di tengah
          dt.isPassword
              ? Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2.0, // Tingkat blur horizontal
                        sigmaY: 2.0, // Tingkat blur vertikal
                      ),
                      child: Container(
                        color: AppColors.bgColor.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              MediaRes.dLock,
                              // ignore: deprecated_member_use
                              color: AppColors.bgBlack,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Locked',
                              style: blackTextstyle.copyWith(
                                fontSize: 13,
                                fontWeight: semiMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
