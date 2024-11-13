// File: lib/core/error/error_handler.dart

class ErrorHandler {
  static String getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid.';
      case 401:
        return 'Tidak dapat mengakses. Harap login kembali.';
      case 403:
        return 'Akses ditolak.';
      case 404:
        return 'Data tidak ditemukan.';
      case 500:
        return 'Terjadi kesalahan internal server.';
      default:
        return 'Terjadi kesalahan pada server.';
    }
  }

  static String getConnectionErrorMessage() {
    return 'Terjadi kesalahan koneksi.';
  }

  static String getTimeoutErrorMessage() {
    return 'Waktu koneksi ke server habis.';
  }

  static String getUnknownErrorMessage() {
    return 'Terjadi kesalahan yang tidak diketahui.';
  }
}
