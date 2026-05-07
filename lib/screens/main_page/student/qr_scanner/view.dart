import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/models/student.dart';
import 'package:pasti/shared/screens/order/controller.dart';
import 'package:sizer/sizer.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isVerifying = false;

  void _onDetect(BarcodeCapture capture) async {
    if (isVerifying) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() => isVerifying = true);
    cameraController.stop();

    try {
      String qrToken = "";
      int userId = student.id; // Use ID from current logged-in user

      // Try to parse as JSON first
      try {
        final Map<String, dynamic> data = jsonDecode(code);
        qrToken = (data['qr_token'] ?? "").toString();

        // If qr_token is missing in JSON, check if the whole JSON is actually the token (fallback)
        if (qrToken.isEmpty && !data.containsKey('qr_token')) {
          qrToken = code.trim();
        }
      } catch (e) {
        // Fallback: If it's not JSON, the code is the token itself
        qrToken = code.trim();
      }

      if (qrToken.isEmpty) {
        _showError("QR Code non valido: token mancante");
        return;
      }

      debugPrint('QR Scanned - Token: $qrToken, UserId: $userId');

      bool success = await verifyQrCodeFunction(context, qrToken, userId);

      if (success) {
        _showSuccess();
      } else {
        // verifyQrCodeFunction already shows snackbar on error
        setState(() => isVerifying = false);
        cameraController.start();
      }
    } catch (e) {
      _showError("Errore durante la scansione: $e");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Errore'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isVerifying = false);
              cameraController.start();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            SizedBox(height: 2.h),
            Text(
              'Consegna Confermata!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              'L\'ordine è stato verificato con successo.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context, true); // return to home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text('Chiudi', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scansiona QR Code'),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          // Scanner Overlay
          Center(
            child: Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                border: Border.all(color: mainColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Inquadra il QR code per verificare la consegna',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
