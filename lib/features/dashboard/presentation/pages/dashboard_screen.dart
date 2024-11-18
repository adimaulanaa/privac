import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/assets/media_res.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/utils/route_helpers.dart';
import 'package:privac/features/dashboard/presentation/pages/create_note_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScreen,
      appBar: AppBar(
        backgroundColor: AppColors.bgScreen,
        toolbarHeight: 60,
        leading: Container(
          margin: const EdgeInsets.only(left: 10, top: 5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(MediaRes.logo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Center(
          child: Text(
            StringResources.nameApp,
            style: blackTextstyle.copyWith(
              fontSize: 28,
              fontWeight: bold,
            ),
          ),
        ),
        actions: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 10, top: 5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.bgColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              MediaRes.horizontal,
              // ignore: deprecated_member_use
              color: AppColors.bgBlack,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      body: const Text('Dashboard'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            createRoute(
              const CreateNoteScreen(),
            ),
          );
        },
        backgroundColor: AppColors.bgMain,
        shape: const CircleBorder(),
        child: SvgPicture.asset(
          MediaRes.dPlus,
          // ignore: deprecated_member_use
          color: AppColors.bgBlack,
          width: 16,
          height: 16,
        ),
      ),
    );
  }
}
