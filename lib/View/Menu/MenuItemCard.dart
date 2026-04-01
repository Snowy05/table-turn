import 'package:flutter/material.dart';
import '../../Model/menuItemModel.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final VoidCallback? onTap;

  const MenuItemCard({Key? key, required this.item, this.onTap})
    : super(key: key);

  @override
  //wraps the menu item to show name pic and price, when clickd opens the open card
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: item.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.fastfood,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '£${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 15, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
