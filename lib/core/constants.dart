import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Central constants for Gram Setu app.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── API ────────────────────────────────────────────────────────────────────
  /// 1. Set this to true to use a Public Tunnel (best for mobile demos & judges).
  static const bool useTunnel = false; 
  static const String tunnelUrl = 'https://YOUR_TUNNEL_URL.loca.lt'; // Paste URL from 'npm run tunnel'

  /// 2. If true, all systems connect to the _manualIp below.
  static const bool usePhysicalIp = false; 
  static const String _manualIp = 'localhost'; 

  /// Base URL is resolved automatically for any machine running it:
  static String get baseUrl {
    if (useTunnel) return tunnelUrl;
    if (usePhysicalIp) return 'http://$_manualIp:3000';
    
    if (kIsWeb) {
      // If served via web, use current host (e.g., localhost or the machine IP).
      final host = Uri.base.host.isEmpty ? 'localhost' : Uri.base.host;
      return 'http://$host:3000';
    }
    
    // For native platforms running on the same machine as the backend:
    if (Platform.isAndroid) {
      // Android emulators need 10.0.2.2 to see the host machine.
      return 'http://10.0.2.2:3000';
    }
    
    // iOS Simulators, Windows, macOS, etc. can all use 'localhost' directly.
    return 'http://localhost:3000';
  }

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration kRequestTimeout = Duration(seconds: 15);

  // ── Asset Paths ────────────────────────────────────────────────────────────
  /// Correct path for the app logo.
  static const String kLogoPath = 'assets/images/logo.png';
}
