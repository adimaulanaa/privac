import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';
import 'package:privac/core/utils/snackbar_extension.dart';
import 'package:privac/core/utils/text_inputs.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:privac/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:privac/features/profile/presentation/bloc/profile_event.dart';
import 'package:privac/features/profile/presentation/bloc/profile_state.dart';
import 'package:privac/features/profile/presentation/pages/login_screen.dart';
import 'package:privac/features/profile/presentation/pages/profile_screen.dart';

class SiginUpProfile extends StatefulWidget {
  final bool isAdmin;
  const SiginUpProfile({super.key, required this.isAdmin});

  @override
  State<SiginUpProfile> createState() => _SiginUpProfileState();
}

class _SiginUpProfileState extends State<SiginUpProfile> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  ProfileModel profile = ProfileModel();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // body: _bodyData(size, context),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is CreateProfileError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is CreateProfileSuccess) {
            if (state.success != '') {
              context.showSuccesSnackBar(
                state.success,
                onNavigate: () {
                  if (widget.isAdmin) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  }
                }, // bottom close
              );
            }
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(size, context), // Latar belakang utama
                if (state is CreateProfileLoading) ...[
                  Container(
                    color: Colors.black
                        .withOpacity(0.5), // Layar semi-transparan gelap
                  ),
                  const UIDialogLoading(
                      text: StringResources.loading), // Loading overlay
                ],
              ],
            );
          },
        ),
      ),

      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.bgMain,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              _save();
            },
            child: Text(
              'Save',
              style: whiteTextstyle.copyWith(
                fontSize: 24,
                fontWeight: semiBold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Padding _bodyData(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          Center(
            child: Text(
              StringResources.pCreate,
              style: blackTextstyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          textInput(
            'Nama',
            0,
            nameController,
            TextInputType.text,
            [],
            onChanged: (value) {},
          ),
          SizedBox(height: size.height * 0.01),
          textInput(
            'Username',
            0,
            usernameController,
            TextInputType.text,
            [],
            onChanged: (value) {},
          ),
          SizedBox(height: size.height * 0.01),
          textInput(
            'Password',
            0,
            passwordController,
            TextInputType.text,
            [],
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  void _save() {
    String isAdmin = '';
    if (widget.isAdmin) {
      isAdmin = '1';
    }
    profile = ProfileModel(
      name: nameController.text,
      username: usernameController.text,
      password: passwordController.text,
      biomatricId: '',
      faceId: '',
      fingerprintId: '',
      tokens: '',
      isAdmin: isAdmin,
      createdOn: DateTime.now(),
      createdBy: 'ANONIMOUS',
      updatedOn: DateTime.now(),
      updatedBy: 'ANONIMOUS',
    );
    context.read<ProfileBloc>().add(CreateProfile(profile));
  }
}
