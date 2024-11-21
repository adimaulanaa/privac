import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Periksa apakah perangkat mendukung biometrik
  static Future<bool> isBiometricSupported() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  // Fungsi untuk memeriksa apakah perangkat mendukung autentikasi biometrik
  Future<bool> isBiometricAvailables() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Periksa apakah perangkat mendukung Face ID (menggunakan BiometricType.weak)
  static Future<bool> isFaceIdSupported() async {
    try {
      final List<BiometricType> availableBiometrics =
          await _auth.getAvailableBiometrics();
      // Asumsikan Face ID adalah kategori "weak"
      return availableBiometrics.contains(BiometricType.weak);
    } catch (e) {
      return false;
    }
  }

  /// Periksa apakah perangkat mendukung Fingerprint (menggunakan BiometricType.strong)
  static Future<bool> isFingerprintSupported() async {
    try {
      final List<BiometricType> availableBiometrics =
          await _auth.getAvailableBiometrics();
      // Asumsikan Fingerprint adalah kategori "strong"
      return availableBiometrics.contains(BiometricType.strong);
    } catch (e) {
      return false;
    }
  }

  /// Autentikasi menggunakan Biometric (Fingerprint/Face ID)
  // Metode untuk mengautentikasi menggunakan biometrik
  Future<bool> authenticate() async {
    try {
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Authentication error: $e');
      return false;
    }
  }
}
