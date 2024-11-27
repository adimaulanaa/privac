import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privac/core/config/auth_local.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';
import 'package:privac/core/utils/appbar.dart';
import 'package:privac/core/utils/route_helpers.dart';
import 'package:privac/core/utils/snackbar_extension.dart';
import 'package:privac/core/utils/text_inputs.dart';
import 'package:privac/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:privac/features/profile/data/models/security_profile_model.dart';
import 'package:privac/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:privac/features/profile/presentation/bloc/profile_event.dart';
import 'package:privac/features/profile/presentation/bloc/profile_state.dart';
import 'package:privac/features/profile/presentation/pages/login_screen.dart';
import 'package:privac/features/profile/presentation/pages/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  ProfileModel profile = ProfileModel();
  List<ProfileModel> listProfile = [];
  final LocalAuthService _biometricAuth = LocalAuthService();
  final ValueNotifier<bool> isSecurity = ValueNotifier(false);
  final ValueNotifier<bool> isPassword = ValueNotifier(false);
  final ValueNotifier<bool> isTextPassword = ValueNotifier(false);
  final ValueNotifier<bool> isCheckPassword = ValueNotifier(false);
  final ValueNotifier<bool> isFingerprint = ValueNotifier(false);
  String userId = '';
  String password = '';
  String checkChangePassword = '';
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    context.read<ProfileBloc>().add(const GetProfile());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGreySecond,
      appBar: AppBar(
        backgroundColor: AppColors.bgGreySecond,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leading: IconBackAppbar(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
        ),
        title: Center(
          child: Text(
            StringResources.profile,
            style: blackTextstyle.copyWith(
              fontSize: 28,
              fontWeight: bold,
            ),
          ),
        ),
        actions: [
          InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.only(right: 15, top: 5),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.bgColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                MediaRes.logout,
                // ignore: deprecated_member_use
                color: AppColors.bgBlack,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is SecurityError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is ProfileLoaded) {
            if (state.data.isNotEmpty) {
              listProfile = state.data;
              loadData();
            }
          } else if (state is SecuritySuccess) {
            if (state.success != '') {
              afterSecurity();
            }
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(context, size), // Latar belakang utama
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

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Nama',
                      style: blackTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: light,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      ':',
                      style: blackTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: light,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {},
                      style: blackTextstyle.copyWith(
                        fontSize: 17,
                        fontWeight: semiBold,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Nama...',
                        hintStyle: greyTextstyle.copyWith(
                          fontSize: 17,
                          fontWeight: semiBold,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Username',
                      style: blackTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: light,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      ':',
                      style: blackTextstyle.copyWith(
                        fontSize: 15,
                        fontWeight: light,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: usernameController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {},
                      style: blackTextstyle.copyWith(
                        fontSize: 17,
                        fontWeight: semiBold,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Username...',
                        hintStyle: greyTextstyle.copyWith(
                          fontSize: 17,
                          fontWeight: semiBold,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              isAdmin ? _keamanan(size) : const SizedBox.shrink(),
              SizedBox(height: size.height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'List Akun',
                    style: blackTextstyle.copyWith(
                      fontSize: 20,
                      fontWeight: bold,
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        createRoute(
                          const SiginUpProfile(isAdmin: false),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      MediaRes.addUser,
                      width: 25,
                      height: 25,
                      // ignore: deprecated_member_use
                      color: AppColors.bgMain,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _title(),
              const SizedBox(height: 5),
              Container(
                width: double.infinity, // Lebar layar penuh
                height: 1, // Tinggi garis (ketebalan)
                color: Colors.black, // Warna garis
              ),
              const SizedBox(height: 10),
              Column(
                children: listProfile.map((e) {
                  return _list(e);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _title() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            'No.',
            style: blackTextstyle.copyWith(
              fontSize: 15,
              fontWeight: light,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            'Nama',
            style: blackTextstyle.copyWith(
              fontSize: 15,
              fontWeight: light,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Aktif',
            style: blackTextstyle.copyWith(
              fontSize: 15,
              fontWeight: light,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '',
            style: blackTextstyle.copyWith(
              fontSize: 15,
              fontWeight: light,
            ),
          ),
        ),
      ],
    );
  }

  Column _keamanan(Size size) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.06),
        Text(
          'Keamanan Akun',
          style: blackTextstyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  MediaRes.pLocked,
                  width: 20,
                  height: 20,
                  // ignore: deprecated_member_use
                  color: AppColors.bgBlack,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 5),
                Text(
                  'Password',
                  style: blackTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: light,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                // isPassword.value = !isPassword.value;
                if (!isPassword.value) {
                  // securityProfile(false);
                  dialogPopupPassword();
                }
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: isPassword,
                builder: (context, isEnabled, child) {
                  return Container(
                    width: 40,
                    height: 23,
                    decoration: BoxDecoration(
                      color: isEnabled ? AppColors.bgMain : Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Align(
                      alignment: isEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  MediaRes.pFingerprint,
                  width: 20,
                  height: 20,
                  // ignore: deprecated_member_use
                  color: AppColors.bgBlack,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 5),
                Text(
                  'Fingerprint',
                  style: blackTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: light,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                // isFingerprint.value = !isFingerprint.value;
                if (!isFingerprint.value) {
                  _useFingerprintId();
                }
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: isFingerprint,
                builder: (context, isEnabled, child) {
                  return Container(
                    width: 40,
                    height: 23,
                    decoration: BoxDecoration(
                      color: isEnabled ? AppColors.bgMain : Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Align(
                      alignment: isEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _list(ProfileModel dt) {
    bool isAdmin = false;
    if (dt.createdBy == '') {
      isAdmin = true;
    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '${dt.idx}.',
            style: blackTextstyle.copyWith(
              fontSize: 15,
              fontWeight: light,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            dt.name.toString(),
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: blackTextstyle.copyWith(
              fontSize: 15,
              fontWeight: light,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: isAdmin
                ? SvgPicture.asset(
                    MediaRes.checklist,
                    // ignore: deprecated_member_use
                    color: AppColors.bgBlack,
                    fit: BoxFit.contain,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () async {
              if (isAdmin) {
                if (dt.password != '') {
                  bool check = await checkPassword(context, dt.password!);
                  if (check && checkChangePassword == dt.password) {
                    passwordController.text = '';
                    chengeUser(dt);
                  } else {
                    showError('Password Salah!');
                  }
                } else if (dt.fingerprintId != '') {
                  bool isAuthenticated = await _biometricAuth.authenticate();
                  if (isAuthenticated) {
                    chengeUser(dt);
                  }
                }
                // print('admin');
              } else {
                chengeUser(dt);
              }
            },
            child: SvgPicture.asset(
              MediaRes.logout,
              // ignore: deprecated_member_use
              color: AppColors.bgBlue,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';
    int idx = 0;
    for (var e in listProfile) {
      idx += 1;
      e.idx = idx;
      if (e.id == id) {
        profile = e;
      }
    }
    isAdmin = profile.isAdmin != '' ? true : false;
    nameController.text = profile.name ?? '-';
    usernameController.text = profile.username ?? '-';
    password = profile.password ?? '-';
    if (profile.password != '') {
      isSecurity.value = false;
      isPassword.value = true;
      isFingerprint.value = false;
    }
    if (profile.fingerprintId != '') {
      isSecurity.value = true;
      isFingerprint.value = true;
      isPassword.value = false;
    }
  }

  void chengeUser(ProfileModel dt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', dt.id!);
    await prefs.setString('name', dt.name!);
    await prefs.setString('username', dt.username!);
    load();
  }

  void securityProfile(bool type) {
    String pass = '';
    String finger = '';
    if (type) {
      finger = '1';
      pass = password;
      isSecurity.value = true;
    } else {
      finger = '';
      pass = passwordController.text;
      isSecurity.value = false;
    }

    SecurityProfileModel update = SecurityProfileModel(
      password: pass,
      fingerprint: finger,
    );
    context.read<ProfileBloc>().add(SecurityProfile(update));
  }

  void afterSecurity() {
    if (isSecurity.value) {
      isFingerprint.value = true;
      isPassword.value = false;
    } else {
      isFingerprint.value = false;
      isPassword.value = true;
      passwordController.text = '';
    }
  }

  Future<void> _useFingerprintId() async {
    try {
      bool isAuthenticated = await _biometricAuth.authenticate();
      if (isAuthenticated) {
        securityProfile(true);
      }
    } catch (error) {
      // ignore: avoid_print
      print("Error: $error");
    }
  }

  Future<void> dialogPopupPassword() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          // ignore: deprecated_member_use
          child: AlertDialog(
            backgroundColor: AppColors.bgColor, // Warna background abu-abu
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Password',
                  textAlign: TextAlign.center,
                  style: blackTextstyle.copyWith(
                    fontSize: 14,
                    fontWeight: light,
                  ),
                ),
                SizedBox(height: 10.h),
                textInput(
                  'Password',
                  0,
                  passwordController,
                  TextInputType.text,
                  [],
                  onChanged: (value) {
                    if (value != '') {
                      isTextPassword.value = true;
                    } else {
                      isTextPassword.value = false;
                    }
                  },
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    if (isTextPassword.value) {
                      Navigator.of(context).pop();
                      securityProfile(false);
                    }
                  },
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isTextPassword,
                    builder: (context, isEnabled, child) {
                      return Container(
                        height: 45.h,
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                          color:
                              isEnabled ? AppColors.bgMain : AppColors.bgGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: whiteTextstyle.copyWith(
                              fontSize: 15,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkPassword(BuildContext context, String pass) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Mengembalikan `false` jika dialog ditutup tanpa aksi
            Navigator.of(context).pop(false);
          },
          child: AlertDialog(
            backgroundColor: AppColors.bgColor, // Warna background abu-abu
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Password',
                  textAlign: TextAlign.center,
                  style: blackTextstyle.copyWith(
                    fontSize: 14,
                    fontWeight: light,
                  ),
                ),
                SizedBox(height: 10.h),
                textInput(
                  'Password',
                  0,
                  passwordController,
                  TextInputType.text,
                  [],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      isCheckPassword.value = true;
                      checkChangePassword = value;
                    } else {
                      isCheckPassword.value = false;
                    }
                  },
                ),
                SizedBox(height: 10.h),
                ValueListenableBuilder<bool>(
                  valueListenable: isCheckPassword,
                  builder: (context, isEnabled, child) {
                    return InkWell(
                      onTap: () {
                        if (isCheckPassword.value) {
                          // Mengembalikan `true` jika tombol Save ditekan
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: Container(
                        height: 45.h,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color:
                              isEnabled ? AppColors.bgMain : AppColors.bgGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: whiteTextstyle.copyWith(
                              fontSize: 15,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false); // Jika `null`, kembalikan `false`
  }

  void showError(String message) {
    context.showErrorSnackBar(
      message,
      onNavigate: () {}, // bottom close
    );
  }
}
