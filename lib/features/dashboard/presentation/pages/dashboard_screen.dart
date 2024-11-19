import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';
import 'package:privac/core/utils/appbar.dart';
import 'package:privac/core/utils/route_helpers.dart';
import 'package:privac/core/utils/snackbar_extension.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:privac/features/dashboard/presentation/pages/create_note_screen.dart';
import 'package:privac/features/dashboard/presentation/widgets/list_notes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<NotesModel> notes = [];
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
          SizedBox(height: size.height * 0.05),
          const Text('Dashboard'),
          Expanded(
            child: Wrap(
              spacing: 10, // Jarak horizontal antar item
              runSpacing: 10, // Jarak vertikal antar baris
              children: List.generate(notes.length, (index) {
                return ListNotes(size: size, dt: notes[index]);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
