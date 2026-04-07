import 'package:flutter/material.dart';
import '../../Model/shopItemModel.dart';

class OpenRewardCard extends StatelessWidget {
  final ShopItem item;
  final Widget? qrCodeWidget; //pass a QR code widget if needed

  const OpenRewardCard({Key? key, required this.item, this.qrCodeWidget})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 350,
        height: 480,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //only show the QR design element for open card, right now just a sample, in the future related actual qr code
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/qrDesignElement.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 30),
              Text(
                item.name,
                style: Theme.of(context).textTheme.titleLarge, //Reward name
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (qrCodeWidget != null) ...[
                // Show QR code if provided ... for spacing and layout
                qrCodeWidget!,
                const SizedBox(height: 16),
              ],
              Text(
                'Show this to redeem your reward!',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.orange[800]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
