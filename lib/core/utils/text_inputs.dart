import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privac/core/uikit/src/theme/media_colors.dart';
import 'package:privac/core/uikit/src/theme/media_text.dart';

// Fungsi untuk membuat TextFormField dengan warna dinamis
TextFormField textInput(
  String text,
  int isType,
  TextEditingController ctr,
  TextInputType type,
  // FocusNode node,
  List<TextInputFormatter> inputFormatters, {
  Color hintColor = Colors.grey, // Warna default untuk hint text
  Color fillColor = AppColors.bgGreySecond, // Warna default untuk fill color
  Function(String)? onChanged, // Callback untuk onChanged
  Function()? onSubmit, // Callback untuk aksi setelah submit
}) {
  return TextFormField(
    controller: ctr,
    keyboardType: type,
    // focusNode: node,
    decoration: InputDecoration(
      hintText: text,
      hintStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: hintColor, // Menggunakan warna dinamis untuk hint text
      ),
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: fillColor, // Menggunakan warna dinamis untuk fill color
    ),
    maxLines: 1, // Mengatur input teks untuk multi-baris
    style: blackTextstyle.copyWith(
      fontSize: 16,
      fontWeight: light,
    ),
    inputFormatters: inputFormatters,
    onChanged: (value) {
      // Memanggil callback jika ada
      if (onChanged != null) {
        onChanged(value); // Menghubungkan fungsionalitas lain di sini
      }
    },
    onFieldSubmitted: (_) {
      if (onSubmit != null) {
        onSubmit(); // Callback ketika tombol Enter ditekan
      }
    },
  );
}
