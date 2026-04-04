import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Central constants for Gram Setu app.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── API ────────────────────────────────────────────────────────────────────
  /// 1. Set this to true to use a Public Tunnel (Submission Mode).
  static const bool useTunnel = false; 
  static const String tunnelUrl = 'https://open-ears-spend.loca.lt'; 

  /// 2. If true, all systems connect to the _manualIp below (Physical IP Mode).
  static const bool usePhysicalIp = true; 
  static const String _manualIp = '192.168.53.234'; 

  /// --- AUTO RESOLVING BASE URL ---
  static String get baseUrl {
    // If we're on the same machine (Web or Simulator), use localhost for speed and to avoid tunnel bypass screens.
    bool isSameMachine = kIsWeb && (Uri.base.host == 'localhost' || Uri.base.host.isEmpty);
    
    if (useTunnel && !isSameMachine) return tunnelUrl;
    if (usePhysicalIp) return 'http://$_manualIp:3000';
    
    // For local testing on Emulator or Chrome
    if (kIsWeb) {
      final host = Uri.base.host.isEmpty ? 'localhost' : Uri.base.host;
      return 'http://$host:3000';
    }
    
    // On Android Emulator (10.0.2.2 points to localhost of the laptop)
    // NOTE: This will NOT work on a physical phone.
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    
    return 'http://localhost:3000';
  }

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration kRequestTimeout = Duration(seconds: 15);

  // ── Asset Paths ────────────────────────────────────────────────────────────
  /// Correct path for the app logo.
  static const String kLogoPath = 'assets/images/logo.png';
}
