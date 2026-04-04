import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Central constants for Gram Setu app.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── IMPORTANT: HACKATHON CONFIGURATION ───────────────────────────────────────
  
  /// 1. PUBLIC TUNNEL (Recommended for judges & real devices)
  ///    Run 'npm run tunnel' on your backend terminal.
  ///    Set 'useTunnel = true' and paste the URL below.
  static const bool useTunnel = false; 
  static const String tunnelUrl = 'https://some-tunnel-url.loca.lt';

  /// 2. PHYSICAL DEVICE (Use this if using your phone on the SAME Wi-Fi)
  ///    Check your laptop's IP (e.g., cmd -> ipconfig -> IPv4 Address)
  ///    Set 'useNetworkIp' = true and paste YOUR LAPTOP IP below.
  static const bool useNetworkIp = false; 
  static const String _laptopIp = '192.168.1.5'; // Example laptop IP

  /// --- AUTO RESOLVING BASE URL ---
  static String get baseUrl {
    if (useTunnel) return tunnelUrl;
    if (useNetworkIp) return 'http://$_laptopIp:3000';
    
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
