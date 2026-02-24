import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Notifier that indicates whether the last auth succeeded
  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  /// Notifier for user-visible error messages (or null)
  final ValueNotifier<String?> error = ValueNotifier(null);

  /// Check whether the device supports biometric authentication and has biometrics enrolled
  Future<bool> canAuthenticate() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      final bool canCheck = await _auth.canCheckBiometrics;
      return isSupported && canCheck;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  /// Returns the list of available biometric types (e.g., fingerprint, face)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      error.value = e.toString();
      return <BiometricType>[];
    }
  }

  /// Attempts to authenticate the user with biometrics.
  /// Returns true on success, false otherwise.
  Future<bool> authenticate({String reason = 'Please authenticate'}) async {
    try {
      error.value = null;
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      isAuthenticated.value = didAuthenticate;
      return didAuthenticate;
    } catch (e) {
      error.value = e.toString();
      isAuthenticated.value = false;
      return false;
    }
  }

  /// Cancels any ongoing authentication (useful when navigating away)
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (_) {}
  }
}
//should
// Shared instance you can import and use across the app
final FingerprintAuth fingerprintAuth = FingerprintAuth();
