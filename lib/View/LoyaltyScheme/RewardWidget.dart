import 'package:flutter/material.dart';
import '../../Model/shopItemModel.dart';

String _resolvedRewardAssetPath(String assetPath) {
  final normalized = assetPath.trim().replaceAll('\\', '/');

  switch (normalized.toLowerCase()) {
    case 'assets/images/cokemenu.png':
    case 'assets/images/cokemeny.png':
    case 'cokemenu.png':
    case 'cokemeny.png':
      return 'assets/images/cokeMenu.png';
    default:
      return normalized;
  }
}

class RewardWidget extends StatelessWidget {
  final ShopItem item;
  final VoidCallback? onBuy;
  final bool isDisabled;

  const RewardWidget({
    Key? key,
    required this.item,
    this.onBuy,
    this.isDisabled = false,
  }) : super(key: key);
  // wisget for reward item
  @override
  Widget build(BuildContext context) {
    final imagePath = _resolvedRewardAssetPath(item.assetPath);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.local_offer_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${item.price} pts',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isDisabled ? null : onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDisabled
                      ? Colors.grey[400]
                      : Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Buy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
