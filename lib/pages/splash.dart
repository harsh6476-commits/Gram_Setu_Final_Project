
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../core/app_colors.dart';
import '../core/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _statusText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _checkBackendHealth();
  }

  Future<void> _checkBackendHealth() async {
    int retries = 0;
    while (true) {
      if (!mounted) return;
      try {
        setState(() {
          _statusText = retries == 0 
            ? 'Connecting to Gram Setu services...' 
            : 'Server waking up... (Attempt ${retries + 1})';
        });

        final response = await http.get(
          Uri.parse('${AppConstants.baseUrl}/health'),
          headers: AppConstants.apiHeaders,
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          setState(() {
            _statusText = 'Connected successfully!';
          });
          await Future.delayed(const Duration(milliseconds: 800));
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
          return; // Exit loop
        }
      } catch (e) {
        // Failed to connect, will retry
      }
      
      retries++;
      await Future.delayed(const Duration(seconds: 3)); // Wait before retry
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adaptiveBackground(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryTeal.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                AppConstants.kLogoPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.health_and_safety, color: AppColors.primaryTeal, size: 60),
              ),
            ).animate()
             .fadeIn(duration: 800.ms)
             .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack)
             .shimmer(delay: 1.seconds, duration: 1.5.seconds, color: Colors.white30),
            
            const SizedBox(height: 32),
            
            Text(
              'Gram Setu',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.adaptiveTextPrimary(context),
              ),
            ).animate()
             .fadeIn(delay: 500.ms, duration: 800.ms)
             .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            
            const SizedBox(height: 8),
            
            Text(
              'Swasthya Seva Aapke Dwar',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 4,
                color: AppColors.adaptiveTextSecondary(context),
                fontWeight: FontWeight.w300,
              ),
            ).animate()
             .fadeIn(delay: 1.seconds, duration: 800.ms),
            
            const SizedBox(height: 60),
            
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
              ),
            ).animate().fadeIn(delay: 1.5.seconds),
            
            const SizedBox(height: 24),
            
            Text(
              _statusText,
              style: TextStyle(
                color: AppColors.adaptiveTextSecondary(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 1.8.seconds),
          ],
        ),
      ),
    );
  }
}
