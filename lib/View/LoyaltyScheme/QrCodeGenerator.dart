import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Controller/QRCodeService.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({Key? key}) : super(key: key);

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final TextEditingController _pointsController = TextEditingController();
  String? _qrCodeId;
  bool _loading = false;
  String? _error;

  Future<void> _generateQrCode() async {
    setState(() {
      _loading = true;
      _error = null;
      _qrCodeId = null;
    });
    final points = int.tryParse(_pointsController.text);
    if (points == null || points <= 0) {
      setState(() {
        _loading = false;
        _error = 'Please enter a valid number of points.';
      });
      return;
    }
    try {
      final qrCodeId = await QRCodeService().createQRCode(points: points);
      setState(() {
        _qrCodeId = qrCodeId;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to generate QR code: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Generator')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _pointsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Points to award',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _generateQrCode,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Generate QR Code'),
              ),
              if (_error != null) ...[ // ... to conditionally show error message
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 32),
              if (_qrCodeId != null) ...[
                const Text('Print and display this QR code:'),
                const SizedBox(height: 16),
                Center(
                  child: QrImageView(
                    data: _qrCodeId!,
                    version: QrVersions.auto,
                    size: 220.0,
                  ),
                ),
                const SizedBox(height: 16),
                SelectableText('QR Code ID: $_qrCodeId'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
