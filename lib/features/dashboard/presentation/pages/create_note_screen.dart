import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';
import 'package:privac/core/utils/popup.dart';
import 'package:privac/core/utils/text_inputs.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:privac/features/dashboard/presentation/bloc/dashboard_state.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  NotesModel notes = NotesModel();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // body: _bodyData(size, context),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is CreateNotesError) {
            if (state.error != '') {
              errorPopup(context, state.error, () {
                // Navigator.pop(context);
              });
            }
          } else if (state is CreateNotesSuccess) {
            if (state.success != '') {
              succesPopup(context, state.success, () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
                // );
              });
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
            'Title',
            0,
            titleController,
            TextInputType.text,
            [],
            onChanged: (value) {},
          ),
          SizedBox(height: size.height * 0.01),
          textInput(
            'Content',
            0,
            contentController,
            TextInputType.text,
            [],
            onChanged: (value) {},
          ),
          SizedBox(height: size.height * 0.2),
          Center(
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                _save();
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
                    "Save",
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

  void _save() {

    notes = NotesModel(
      title: titleController.text,
      content: contentController.text,
      isPin: 0,
      isLocked: 0,
      biomatricId: '',
      faceId: '',
      primaryKey: '',
      createdOn: DateTime.now(),
      createdBy: '',
      updatedOn: DateTime.now(),
      updatedBy: '',
    );
    context.read<DashboardBloc>().add(CreateNotes(notes));
  }
}
