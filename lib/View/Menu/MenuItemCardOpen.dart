import 'package:flutter/material.dart';
import '../../Model/menuItemModel.dart';

class MenuItemCardOpen extends StatelessWidget {
  final MenuItemModel item;
  final VoidCallback? onClose;

  const MenuItemCardOpen({Key? key, required this.item, this.onClose})
    : super(key: key);

  @override
  // This widget is a dialog that shows the details of a menu item, it is opened when the user taps 
  //on a menu item card, it shows the image, name, description, price, calories, category 
  //and tags of the menu item
  //color coded tags, blue for menu tags and green for dietary tags
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: item.imageUrl.isNotEmpty
                      ? Image.asset(
                          item.imageUrl,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 180,
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.fastfood,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '£${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  if (item.calories.isNotEmpty)
                    Text(
                      '${item.calories} kcal',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (item.category.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: item.category
                      .map((cat) => Chip(label: Text(cat)))
                      .toList(),
                ),
              if (item.menuTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    children: item.menuTags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.blue[50],
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (item.dietaryTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    children: item.dietaryTags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.green[50],
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
