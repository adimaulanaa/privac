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
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:privac/features/dashboard/presentation/pages/create_note_screen.dart';
import 'package:privac/features/dashboard/presentation/pages/view_note_screen.dart';
import 'package:privac/features/dashboard/presentation/widgets/list_notes.dart';
import 'package:privac/features/profile/presentation/pages/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LocalAuthService _biometricAuth = LocalAuthService();
  final searchController = TextEditingController();
  final passwordController = TextEditingController();
  final ValueNotifier<bool> isTextPassword = ValueNotifier(false);
  List<NotesModel> notes = [];
  List<NotesModel> filterNotes = [];
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const GetDashboard());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGreySecond,
      appBar: AppBar(
        backgroundColor: AppColors.bgGreySecond,
        toolbarHeight: 70,
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              createRoute(
                const ProfileScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, top: 5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(MediaRes.logo),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Center(
          child: Text(
            StringResources.titleApp,
            style: blackTextstyle.copyWith(
              fontSize: 28,
              fontWeight: bold,
            ),
          ),
        ),
        actions: [
          IconDots(
            img: MediaRes.horizontal,
            onTap: () {},
          ),
        ],
      ),
      // body: const Text('Dashboard'),
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
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            if (state.dashboard != '') {
              context.showErrorSnackBar(
                state.dashboard,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is DashboardLoaded) {
            if (state.data.isNotEmpty) {
              notes = state.data;
              filterNotes = notes;
            }
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(size, context), // Latar belakang utama
                if (state is CreateNotesLoading) ...[
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
    );
  }

  Padding _bodyData(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.01),
          // const Text('Dashboard'),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Note...',
                hintStyle: greyTextstyle.copyWith(
                  fontSize: 16,
                  fontWeight: light,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.bgTrans,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: InputBorder.none,
                filled: true,
                fillColor: AppColors.bgColor,
                // Menambahkan ikon di kiri
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    MediaRes.dSearch, // Ganti dengan ikon kiri yang sesuai
                    // ignore: deprecated_member_use
                    color: AppColors.bgGrey,
                    width: 20, // Sesuaikan ukuran ikon
                  ),
                ),
                // Ikon di kanan tetap ada
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      searchController.text = '';
                      search('');
                    },
                    child: SvgPicture.asset(
                      MediaRes.dSearchRight,
                      // ignore: deprecated_member_use
                      color: AppColors.bgGrey,
                      width: 20, // Sesuaikan ukuran ikon
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 14.0),
              ),
              onChanged: (value) {
                search(value);
              },
              maxLines: 1,
              style: blackTextstyle.copyWith(
                fontSize: 16,
                fontWeight: light,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: filterNotes.isNotEmpty
                ? Wrap(
                    spacing: 10, // Jarak horizontal antar item
                    runSpacing: 10, // Jarak vertikal antar baris
                    children: List.generate(filterNotes.length, (index) {
                      NotesModel dt = filterNotes[index];
                      return InkWell(
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            checkRoute(dt);
                          },
                          child: ListNotes(size: size, dt: filterNotes[index]));
                    }),
                  )
                : Center(
                    child: Text(
                      "Notes tidak tersedia",
                      style: greyTextstyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void checkRoute(NotesModel dt) async {
    String errorMessage = '';
    if (dt.password != '') {
      bool check = await dialogPopupPassword(context, dt.password!);
      if (check) {
        detailNote(dt);
      } else {
        passwordController.text = '';
        errorMessage = 'Password Salah';
      }
    } else if (dt.fingerprintId != '') {
      bool isAuthenticated = await _biometricAuth.authenticate();
      if (isAuthenticated) {
        detailNote(dt);
      }
    } else {
      detailNote(dt);
    }
    if (errorMessage != '') {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        'Password Salah',
        onNavigate: () {}, // bottom close
      );
    }
  }

  Future<bool> dialogPopupPassword(
      BuildContext context, String password) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pop(false); // Tutup dialog dan kirim false
              },
              child: AlertDialog(
                backgroundColor: AppColors.bgColor,
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
                        isTextPassword.value = value.isNotEmpty;
                      },
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: () {
                        if (isTextPassword.value &&
                            passwordController.text == password) {
                          Navigator.of(context)
                              .pop(true); // Kirim true saat sukses
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isTextPassword,
                        builder: (context, isEnabled, child) {
                          return Container(
                            height: 45.h,
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                              color: isEnabled
                                  ? AppColors.bgMain
                                  : AppColors.bgGrey,
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
        ) ??
        false; // Default ke false jika dialog ditutup tanpa input
  }

  void search(String value) {
    final lowerCaseQuery = value.toLowerCase();
    setState(() {
      filterNotes = notes.where((e) {
        final title = e.title!.toLowerCase();
        bool matchesQuery = title.contains(lowerCaseQuery);
        return matchesQuery;
      }).toList();
    });
  }

  void detailNote(NotesModel dt) {
    Navigator.push(
      context,
      createRoute(
        ViewNoteScreen(note: dt),
      ),
    );
  }
}
