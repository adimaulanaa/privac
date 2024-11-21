import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:privac/core/config/auth_local.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';
import 'package:privac/core/utils/appbar.dart';
import 'package:privac/core/utils/snackbar_extension.dart';
import 'package:privac/core/utils/text_inputs.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/data/models/update_security_model.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:privac/features/dashboard/presentation/pages/dashboard_screen.dart';

class ViewNoteScreen extends StatefulWidget {
  final NotesModel note;
  const ViewNoteScreen({super.key, required this.note});

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final passwordController = TextEditingController();
  String biomatricId = '';
  String faceId = '';
  String fingerprintId = '';
  String tokens = '';
  bool isNoSecurity = false;
  bool isSaved = false;
  bool isPin = false;
  bool isPassword = false;
  bool isBiomatric = false;
  bool isSupportBiomatric = false;
  bool isFace = false;
  bool isSupportFace = false;
  bool isFingerprint = false;
  bool isSupportFingerprint = false;
  bool _isAuthenticated = false;
  final LocalAuthService _biometricAuth = LocalAuthService();
  final ValueNotifier<bool> isTextPassword = ValueNotifier(false);
  String username = '';
  String usernameId = '';
  int isTypeSecurity = 0;
  DateTime dates = DateTime.now();
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  NotesModel notes = NotesModel();
  NotesModel saved = NotesModel();

  @override
  void initState() {
    super.initState();
    notes = widget.note;
    usernameId = notes.id ?? '';
    titleController.text = notes.title ?? '-';
    contentController.text = notes.content ?? '-';
    dates = notes.createdOn ?? DateTime.now();
    if (usernameId != '') {
      isSaved = true;
    }
    if (notes.isPin == 1) {
      isPin = true;
    }
    if (notes.password != '') {
      isPassword = true;
    }
    if (notes.fingerprintId != '') {
      isFingerprint = true;
    }
    loadAuthLocal();
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
        actions: [
          _toggleSetting(),
          IconSaveAppbar(
            onTap: () {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                _save();
              }
            },
          ),
        ],
      ),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is UpdateNotesError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is UpdatePinNotesError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is UpdateSecurityNotesError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is UpdateNotesSuccess) {
            if (state.success != '') {
              context.showSuccesSnackBar(
                state.success,
                onNavigate: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const DashboardScreen()),
                  // );
                }, // bottom close
              );
            }
          } else if (state is UpdatePinNotesSuccess) {
            if (state.success != '') {
              context.showSuccesSnackBar(
                state.success,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is UpdateSecurityNotesSuccess) {
            if (state.success != '') {
              setAfterAction(state.type);
              context.showSuccesSnackBar(
                state.success,
                onNavigate: () {}, // bottom close
              );
            }
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(size, context), // Latar belakang utama
                if (state is UpdateNotesLoading ||
                    state is UpdatePinNotesLoading ||
                    state is UpdateSecutiryNotesLoading) ...[
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  const UIDialogLoading(text: StringResources.loading),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  PopupMenuButton<String> _toggleSetting() {
    return PopupMenuButton<String>(
      elevation: 9,
      onSelected: (value) {
        if (value == 'pin') {
          isPin = !isPin;
          if (isPin) {
            context
                .read<DashboardBloc>()
                .add(UpdatePinNotes(id: usernameId, pin: 1));
          } else {
            context
                .read<DashboardBloc>()
                .add(UpdatePinNotes(id: usernameId, pin: 0));
          }
        } else if (value == 'password') {
          if (isPassword) {
            sendNoSecurity();
          } else {
            dialogPopupPassword();
          }
        } else if (value == 'fingerprint') {
          if (isFingerprint) {
            sendNoSecurity();
          } else {
            _loginBiometric();
          }
        }
      },
      icon: Container(
        width: 42,
        height: 42,
        padding: const EdgeInsets.all(9),
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
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'pin',
          child: _textSetting('Pin', isPin),
        ),
        PopupMenuItem(
          value: 'password',
          child: _textSetting('Password', isPassword),
        ),
        // if (isSupportBiomatric) PopupMenuItem(
        //   value: 'biomatric',
        //   child: _textSetting('Biomatric', isBiomatric),
        // ),
        if (isSupportFingerprint)
          PopupMenuItem(
            value: 'fingerprint',
            child: _textSetting('Fingerprint', isFingerprint),
          ),
        if (isSupportFace)
          PopupMenuItem(
            value: 'face',
            child: _textSetting('Face', isFace),
          ),
      ],
    );
  }

  Row _textSetting(String text, bool isOn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: blackTextstyle.copyWith(
            fontSize: 12,
            fontWeight: light,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          width: 40,
          height: 23,
          decoration: BoxDecoration(
            color: isOn ? AppColors.bgMain : Colors.grey,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Align(
            alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
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
        ),
      ],
    );
  }

  Padding _bodyData(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: size.height * 0.05),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: titleFocus,
              autofocus: true,
              controller: titleController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSubmitted: (text) {
                titleFocus.unfocus();
                FocusScope.of(context).requestFocus(contentFocus);
              },
              onChanged: (value) {
                // markTitleAsDirty(value);
              },
              textInputAction: TextInputAction.next,
              style: blackTextstyle.copyWith(
                fontSize: 25,
                fontWeight: bold,
              ),
              decoration: InputDecoration.collapsed(
                hintText: 'Enter a title',
                hintStyle: greyTextstyle.copyWith(
                  fontSize: 25,
                  fontWeight: bold,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 15),
            child: Text(
              formatDate(dates),
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: greyTextstyle.copyWith(
                fontSize: 12,
                fontWeight: light,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: contentFocus,
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  // markContentAsDirty(value);
                },
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: medium,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: 'Start typing...',
                  hintStyle: greyTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: medium,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    saved = NotesModel(
      id: notes.id,
      title: titleController.text,
      content: contentController.text,
      isPin: notes.isPin,
      isLocked: notes.isLocked,
      biomatricId: notes.biomatricId,
      faceId: notes.faceId,
      tokens: notes.tokens,
      createdId: notes.createdId,
      password: notes.password,
      createdOn: notes.createdOn,
      createdBy: notes.createdBy,
      updatedOn: DateTime.now(),
      updatedBy: notes.updatedBy,
    );
    context.read<DashboardBloc>().add(UpdateNotes(saved));
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
                      sendSaved(1);
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

  void sendSaved(int type) {
    isNoSecurity = true;
    if (type == 1) {
      isTypeSecurity = 1;
      biomatricId = '';
      faceId = '';
      fingerprintId = '';
      tokens = '';
    } else if (type == 2) {
      isTypeSecurity = 2;
      fingerprintId = '1';
      biomatricId = '';
      faceId = '';
      tokens = '';
      passwordController.text = '';
    }
    UpdateSecurityModel save = UpdateSecurityModel(
      id: usernameId,
      password: passwordController.text,
      biomatricId: biomatricId,
      faceId: faceId,
      fingerprintId: fingerprintId,
      tokens: tokens,
    );
    context
        .read<DashboardBloc>()
        .add(UpdateSecurityNotes(save: save, type: isTypeSecurity));
  }

  void sendNoSecurity() {
    isPassword = false;
    isBiomatric = false;
    isFace = false;
    isFingerprint = false;
    isNoSecurity = false;
    UpdateSecurityModel save = UpdateSecurityModel(
      id: usernameId,
      password: '',
      biomatricId: '',
      faceId: '',
      fingerprintId: '',
      tokens: '',
    );
    context
        .read<DashboardBloc>()
        .add(UpdateSecurityNotes(save: save, type: isTypeSecurity));
  }

  void setAfterAction(int type) {
    if (isNoSecurity) {
      if (type == 1) {
        isPassword = true;
        isBiomatric = false;
        isFace = false;
        isFingerprint = false;
      } else if (type == 2) {
        isFingerprint = true;
        isPassword = false;
        isBiomatric = false;
        isFace = false;
      }
    } else {
      isPassword = false;
      isBiomatric = false;
      isFace = false;
      isFingerprint = false;
    }
  }

  String formatDate(DateTime dateTime) {
    // Setel locale ke 'id_ID' untuk bahasa Indonesia
    // Intl.defaultLocale = 'id_ID';
    // Format tanggal sesuai yang diinginkan
    String formattedDate =
        DateFormat('EEEE, MMMM dd, yyyy HH:mm').format(dateTime);
    return formattedDate;
  }

  Future<void> _loginBiometric() async {
    try {
      _isAuthenticated = await _biometricAuth.authenticate();
      if (_isAuthenticated) {
        sendSaved(2);
      }
    } catch (error) {
      // ignore: avoid_print
      print("Error: $error");
    }
  }

  void loadAuthLocal() async {
    isSupportBiomatric = await LocalAuthService.isBiometricSupported();
    isSupportFace = await LocalAuthService.isFaceIdSupported();
    isSupportFingerprint = await LocalAuthService.isFingerprintSupported();
  }
}
