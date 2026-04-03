/// Central constants for Gram Setu app.
/// Change [kBaseUrl] to match your backend server's IP/host.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── API ────────────────────────────────────────────────────────────────────
  /// Base URL of the Node.js backend.
  /// ✅ Flutter Web (browser on same machine as server) → use localhost
  /// ✅ Physical device / emulator on the same Wi-Fi  → use 10.0.1.45
  static const String kBaseUrl = 'http://localhost:3000';

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration kRequestTimeout = Duration(seconds: 15);

  // ── Asset Paths ────────────────────────────────────────────────────────────
  /// Correct path for the app logo.
  /// In pubspec.yaml declare:  assets: - assets/images/
  static const String kLogoPath = 'assets/images/logo.png';
}

