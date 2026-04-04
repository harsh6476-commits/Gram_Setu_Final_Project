import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/app_colors.dart';
import '../widgets/gram_app_bar.dart';

class RPPGMonitorScreen extends StatefulWidget {
  const RPPGMonitorScreen({super.key});

  @override
  State<RPPGMonitorScreen> createState() => _RPPGMonitorScreenState();
}

class _RPPGMonitorScreenState extends State<RPPGMonitorScreen> {
  CameraController? _controller;
  bool _isPermissionGranted = false;
  bool _isScanning = false;
  double _heartRate = 0;
  List<double> _signalData = [];
  Timer? _scanTimer;
  String _statusMessage = 'Align your face within the frame';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final frontCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );
        _controller = CameraController(frontCamera, ResolutionPreset.medium);
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isPermissionGranted = true;
          });
        }
      }
    }
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
      _heartRate = 0;
      _signalData.clear();
      _statusMessage = 'Analyzing blood flow... Keep still';
    });

    int count = 0;
    _scanTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (count < 50) {
        setState(() {
          // Mocking pulse data
          _signalData.add(60 + (count % 10).toDouble());
        });
        count++;
      } else {
        _stopScanning();
      }
    });
  }

  void _stopScanning() {
    _scanTimer?.cancel();
    setState(() {
      _isScanning = false;
      _heartRate = 72 + (DateTime.now().millisecond % 10); // Mock final result
      _statusMessage = 'Scan Complete';
    });
    
    _showResultDialog();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Heart Rate: ${_heartRate.toInt()} BPM',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Estimated via rPPG analysis'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, save to backend
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vitals updated successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
            child: const Text('Save to Vitals'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionGranted) {
      return const Scaffold(
        appBar: GramAppBar(showBack: true),
        body: Center(child: Text('Camera permission required')),
      );
    }

    return Scaffold(
      appBar: const GramAppBar(showBack: true, roleLabel: 'rPPG Monitor'),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryTeal, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_controller != null && _controller!.value.isInitialized)
                      CameraPreview(_controller!)
                    else
                      const Center(child: CircularProgressIndicator()),
                    
                    // Face focus frame
                    Container(
                      width: 250,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isScanning ? Colors.green : Colors.white54,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                    
                    if (_isScanning)
                      const Positioned(
                        top: 40,
                        child: Text(
                          'SCANNING...',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  if (_isScanning)
                    const LinearProgressIndicator(color: AppColors.primaryTeal)
                  else
                    ElevatedButton.icon(
                      onPressed: _startScanning,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Heart Rate Scan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Remote photoplethysmography (rPPG) measures volumetric changes in blood circulation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
