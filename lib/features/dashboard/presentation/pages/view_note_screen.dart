import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:privac/core/config/config_resources.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';
import 'package:privac/core/uikit/uikit.dart';
import 'package:privac/core/utils/appbar.dart';
import 'package:privac/core/utils/popup.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
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
  String username = '';
  int usernameId = 0;
  DateTime dates = DateTime.now();
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  NotesModel notes = NotesModel();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title ?? '-';
    contentController.text = widget.note.content ?? '-';
    dates = widget.note.createdOn ?? DateTime.now();
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
          if (state is CreateNotesError) {
            if (state.error != '') {
              errorPopup(context, state.error, () {
                // Navigator.pop(context);
              });
            }
          } else if (state is CreateNotesSuccess) {
            if (state.success != '') {
              succesPopup(context, state.success, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
                );
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
    notes = NotesModel(
      title: titleController.text,
      content: contentController.text,
      isPin: 0,
      isLocked: 0,
      biomatricId: '',
      faceId: '',
      primaryKey: '',
      password: '',
      createdOn: DateTime.now(),
      createdBy: '',
      updatedOn: DateTime.now(),
      updatedBy: '',
    );
    context.read<DashboardBloc>().add(CreateNotes(notes));
  }

  String formatDate(DateTime dateTime) {
    // Setel locale ke 'id_ID' untuk bahasa Indonesia
    // Intl.defaultLocale = 'id_ID';
    // Format tanggal sesuai yang diinginkan
    String formattedDate =
        DateFormat('EEEE, MMMM dd, yyyy HH:mm').format(dateTime);
    return formattedDate;
  }
}
