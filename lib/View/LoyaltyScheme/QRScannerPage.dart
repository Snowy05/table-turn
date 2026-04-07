import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../Controller/QRCodeRedemptionController.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool _processing = false;
  String? _resultMessage;

  Future<void> _handleCapture(BarcodeCapture capture) async {
    if (_processing) return;
    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    if (barcode == null || barcode.rawValue == null) return;
    setState(() => _processing = true);
    final codeId = barcode.rawValue!;
    final controller = QRCodeRedemptionController();
    try {
      final points = await controller.redeemScannedCode(codeId);
      if (points != null) {
        setState(() {
          _resultMessage = 'Points added!';
        });
      }
      // Do not clear the message on error or repeat scan to allow user to see the success message until they scan another code
    } catch (e) {
      // Do not show any message on error for now, just ignore and allow rescanning
    } finally {
      setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Center(
            //Added some design to scanner
            child: SizedBox(
              width: 280,
              height: 280,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(onDetect: _handleCapture),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _resultMessage ?? 'Find an easter egg QR code in the Cafe to earn points!',
              style: TextStyle(
                color: _resultMessage != null ? Colors.green : Colors.black54,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
