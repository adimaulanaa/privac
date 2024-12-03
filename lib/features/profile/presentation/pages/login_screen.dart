import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privac/core/config/auth_local.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';
import 'package:privac/core/utils/route_helpers.dart';
import 'package:privac/core/utils/snackbar_extension.dart';
import 'package:privac/core/utils/text_inputs.dart';
import 'package:privac/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:privac/features/profile/presentation/bloc/profile_event.dart';
import 'package:privac/features/profile/presentation/bloc/profile_state.dart';
import 'package:privac/features/profile/presentation/pages/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDataUser = false;
  int isSecurity = 0;
  final LocalAuthService _biometricAuth = LocalAuthService();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginModel login = LoginModel();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const CheckProfile());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is CheckProfileError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is LoginError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is CheckProfileLoaded) {
            if (state.check.check == true) {
              isDataUser = true;
              isSecurity = state.check.isSecurity ?? 0;
            }
          } else if (state is LoginSuccess) {
            context.showSuccesSnackBar(
              state.success,
              onNavigate: () {
                moveDash();
              }, // bottom close
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(size, context), // Latar belakang utama
                if (state is CheckProfileLoading || state is LoginLoading) ...[
                  // Layar semi-transparan gelap
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  // Loading overlay
                  const UIDialogLoading(text: StringResources.loading),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  SingleChildScrollView _bodyData(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          Center(
            child: Text(
              StringResources.nameApp,
              style: blackTextstyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Center(
            child: Text(
              StringResources.welcome,
              style: blackTextstyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.1),
          isDataUser
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: _login(size),
                )
              : Center(
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        createRoute(
                          const SiginUpProfile(isAdmin: true),
                        ),
                      );
                    },
                    child: Container(
                      width: 200.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.bgMain,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          "Setup Profile",
                          style: whiteTextstyle.copyWith(
                            fontSize: 20,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  InkWell _biomatric() {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        _useFingerprintId();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SvgPicture.asset(
          MediaRes.pFingerprint,
          width: 60.w,
          height: 60.h,
          // ignore: deprecated_member_use
          color: AppColors.bgRed,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Column _login(Size size) => Column(
        children: [
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
            onSubmit: () {
              sendLogin();
            },
          ),
          SizedBox(height: size.height * 0.1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  sendLogin();
                },
                child: Container(
                  width: 200.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.bgMain,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: whiteTextstyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ),
              isSecurity == 2 ? _biomatric() : const SizedBox.shrink()
            ],
          ),
        ],
      );

  void sendLogin() {
    login = LoginModel(
      username: usernameController.text,
      password: passwordController.text,
    );
    context.read<ProfileBloc>().add(LoginProfile(login));
  }

  Future<void> _useFingerprintId() async {
    try {
      bool isAuthenticated = await _biometricAuth.authenticate();
      if (isAuthenticated) {
        moveDash();
      }
    } catch (error) {
      // ignore: avoid_print
      print("Error: $error");
    }
  }

  void moveDash() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }
}
