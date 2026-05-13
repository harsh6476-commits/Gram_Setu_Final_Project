import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Central constants for Gram Setu app.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── API ────────────────────────────────────────────────────────────────────
  /// 1. Set this to true to use a Public Tunnel (Submission Mode).
  static const bool useTunnel = true; 
  static const String tunnelUrl = 'https://sharp-boxes-share.loca.lt'; 

  /// 2. If true, all systems connect to the _manualIp below (Physical IP Mode).
  static const bool usePhysicalIp = false; 
  static const String _manualIp = '10.31.44.55';

  /// --- DYNAMIC OVERRIDE (For Hackathon APK testing) ---
  static String? customBaseUrl;

  /// --- AUTO RESOLVING BASE URL ---
  static String get baseUrl {
    // 1. If user set a custom URL in the app, ALWAYS use that first.
    if (customBaseUrl != null && customBaseUrl!.isNotEmpty) {
      return customBaseUrl!;
    }

    // If we're on the same machine (Web or Simulator), use localhost for speed and to avoid tunnel bypass screens.
    bool isSameMachine = kIsWeb && (Uri.base.host == 'localhost' || Uri.base.host.isEmpty);
    
    // For local testing on Emulator or Chrome, always favor localhost
    if (isSameMachine) return 'http://localhost:3000';
    
    if (useTunnel) return tunnelUrl;
    
    if (usePhysicalIp) return 'http://$_manualIp:3000';
    
    // On Android Emulator (10.0.2.2 points to localhost of the laptop)
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    
    return 'http://localhost:3000';
  }

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration kRequestTimeout = Duration(seconds: 15);

  // ── Asset Paths ────────────────────────────────────────────────────────────
  /// Correct path for the app logo.
  static const String kLogoPath = 'assets/images/logo.png';

  // ── Common API Headers ───────────────────────────────────────────────────────
  static Map<String, String> get apiHeaders => {
    'Content-Type': 'application/json',
    'Bypass-Tunnel-Reminder': 'true', // Bypasses Localtunnel security warning
    'ngrok-skip-browser-warning': 'true', // Bypasses ngrok security warning
  };
}
