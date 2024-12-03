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
import 'package:privac/features/dashboard/presentation/widgets/view_note_widget.dart';

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
  String passwordId = '';
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
  bool isMenu = true;
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
      passwordId = notes.password.toString();
    }
    if (notes.fingerprintId != '') {
      isFingerprint = true;
      fingerprintId = notes.fingerprintId.toString();
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
          } else if (state is CreateNotesError) {
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
              passwordController.text = '';
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is DeleteNotesError) {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
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
          } else if (state is DeleteNotesSuccess) {
            if (state.success != '') {
              context.showSuccesSnackBar(
                state.success,
                onNavigate: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                }, // bottom close
              );
            }
          } else if (state is CreateNotesSuccess) {
            if (state.success != '') {
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
                    state is UpdateSecutiryNotesLoading ||
                    state is DeleteNotesLoading ||
                    state is CreateNotesLoading) ...[
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
      floatingActionButton:
          isMenu ? _menuFloating(context) : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  fontWeight: light,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: 'Start typing...',
                  hintStyle: greyTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: light,
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

  Container _menuFloating(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 55.h,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {},
              child: viewSvg(MediaRes.vOther),
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {},
              child: viewSvg(MediaRes.vOther),
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {},
              child: viewSvg(MediaRes.vOther),
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {},
              child: viewSvg(MediaRes.vOther),
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                showOtherMenu(context, size);
              },
              child: viewSvg(MediaRes.vOther),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showOtherMenu(BuildContext context, Size size) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size.width,
                height: size.height * 0.56,
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: IconRowMenu(
                                  size: size,
                                  text: 'Image',
                                  img: MediaRes.vOther),
                            ),
                            InkWell(
                              onTap: () {},
                              child: IconRowMenu(
                                  size: size,
                                  text: 'Voice',
                                  img: MediaRes.vOther),
                            ),
                            InkWell(
                              onTap: () {},
                              child: IconRowMenu(
                                  size: size,
                                  text: 'Share',
                                  img: MediaRes.vOther),
                            ),
                          ],
                        ),
                      ),
                    ),
                    dividers(),
                    5.verticalSpace,
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        isPin = !isPin;
                        Navigator.of(context).pop();
                        if (isPin) {
                          context
                              .read<DashboardBloc>()
                              .add(UpdatePinNotes(id: usernameId, pin: 1));
                        } else {
                          context
                              .read<DashboardBloc>()
                              .add(UpdatePinNotes(id: usernameId, pin: 0));
                        }
                      },
                      child: ViewListOther(
                        text: isPin ? 'Unpin' : 'Pin',
                        img: MediaRes.dPin,
                        colors: AppColors.bgBlack,
                      ),
                    ),
                    5.verticalSpace,
                    dividers(),
                    5.verticalSpace,
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        //
                      },
                      child: ViewListOther(
                        text: 'Add Thumbnail',
                        img: MediaRes.vThumbnail,
                        colors: AppColors.bgBlack,
                      ),
                    ),
                    5.verticalSpace,
                    dividers(),
                    5.verticalSpace,
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        //
                      },
                      child: ViewListOther(
                        text: 'Label',
                        img: MediaRes.vLabel,
                        colors: AppColors.bgBlack,
                      ),
                    ),
                    5.verticalSpace,
                    dividers(),
                    5.verticalSpace,
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        //
                      },
                      child: ViewListOther(
                        text: 'Share',
                        img: MediaRes.dPin,
                        colors: AppColors.bgBlack,
                      ),
                    ),
                    5.verticalSpace,
                    dividers(),
                    5.verticalSpace,
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                        _makeCopy();
                      },
                      child: ViewListOther(
                        text: 'Make a Copy',
                        img: MediaRes.vCopy,
                        colors: AppColors.bgBlack,
                      ),
                    ),
                    5.verticalSpace,
                    dividers(),
                    5.verticalSpace,
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                        if (isSupportFingerprint) {
                          popupSelectSecurity();
                        } else {
                          dialogPopupPassword();
                        }
                      },
                      child: ViewListOther(
                        text: isPassword || isFingerprint
                            ? 'Unlock Note'
                            : 'Lock Note',
                        img: MediaRes.dLock,
                        colors: AppColors.bgBlack,
                      ),
                    ),
                    5.verticalSpace,
                    dividers(),
                    5.verticalSpace,
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                        if (usernameId != '') {
                          context
                              .read<DashboardBloc>()
                              .add(DeleteNotes(id: usernameId));
                        }
                      },
                      child: ViewListOther(
                        text: 'Delete Note',
                        img: MediaRes.delete,
                        colors: AppColors.bgRed,
                      ),
                    ),
                    5.verticalSpace,
                    dividers(),
                    5.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        'Last Edit ${formatDate(dates)} By ${notes.createdBy}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: greyTextstyle.copyWith(
                          fontSize: 12,
                          fontWeight: light,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -15.0,
                left: size.width * 0.41,
                child: SvgPicture.asset(
                  MediaRes.line,
                  // ignore: deprecated_member_use
                  color: AppColors.bgColor,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      },
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

  void _makeCopy() {
    NotesModel copyNotes = NotesModel(
      title: '${titleController.text} Copy',
      content: contentController.text,
      images: '',
      labelName: '',
      labelId: 0,
      isPin: 0,
      isLocked: 0,
      biomatricId: '',
      faceId: '',
      fingerprintId: '',
      tokens: '',
      password: '',
      createdOn: DateTime.now(),
      createdBy: '',
      updatedOn: DateTime.now(),
      updatedBy: '',
    );
    context.read<DashboardBloc>().add(CreateNotes(copyNotes));
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
                      sendSecurity(1, true);
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

  Future<void> popupSelectSecurity() {
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
            content: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (isPassword) {
                      sendUnSecurity(1);
                    } else {
                      dialogPopupPassword();
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        // color: backgroundColor,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: viewSvg(MediaRes.pLocked)),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (isPassword) {
                      sendUnSecurity(2);
                    } else {
                      _useFingerprintId();
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        // color: backgroundColor,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: viewSvg(MediaRes.pFingerprint)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void sendUnSecurity(int type) {
    isNoSecurity = true;
    if (type == 1) {
      isTypeSecurity = type;
      passwordId = '';
    } else if (type == 2) {
      isTypeSecurity = type;
      fingerprintId = '';
    }
    UpdateSecurityModel save = UpdateSecurityModel(
      id: usernameId,
      password: passwordId,
      biomatricId: biomatricId,
      faceId: faceId,
      fingerprintId: fingerprintId,
      tokens: tokens,
    );
    context
        .read<DashboardBloc>()
        .add(UpdateSecurityNotes(save: save, type: isTypeSecurity));
  }

  void sendSecurity(int type, bool isActive) {
    isPassword = false;
    isBiomatric = false;
    isFace = false;
    isFingerprint = false;
    isNoSecurity = false;
    if (type == 1) {
      if (isActive) {
        passwordId = passwordController.text;
      } else {
        passwordId = '';
      }
    } else if (type == 2) {
      if (isActive) {
        fingerprintId = '1';
      } else {
        passwordId = '';
      }
    }
    UpdateSecurityModel save = UpdateSecurityModel(
      id: usernameId,
      password: passwordId,
      biomatricId: biomatricId,
      faceId: faceId,
      fingerprintId: fingerprintId,
      tokens: tokens,
    );
    context
        .read<DashboardBloc>()
        .add(UpdateSecurityNotes(save: save, type: isTypeSecurity));
  }

  void setAfterAction(int type) {
    passwordController.text = '';
  }

  String formatDate(DateTime dateTime) {
    // Setel locale ke 'id_ID' untuk bahasa Indonesia
    // Intl.defaultLocale = 'id_ID';
    // Format tanggal sesuai yang diinginkan
    String formattedDate =
        DateFormat('EEEE, MMMM dd, yyyy HH:mm').format(dateTime);
    return formattedDate;
  }

  Future<void> _useFingerprintId() async {
    try {
      bool isAuthenticated = await _biometricAuth.authenticate();
      if (isAuthenticated) {
        sendSecurity(2, true);
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
