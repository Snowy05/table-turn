class MenuItemModel {
  final String uid;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  //could bee drink, food, combo or other
  final List<String> category;
  final bool isAvailable;
final String calories;
  final List<String> menuTags;
  final List<String> dietaryTags;

  MenuItemModel({
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.calories,
    required this.menuTags,
    required this.dietaryTags,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    return MenuItemModel(
      uid: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      category: List<String>.from(data['category'] ?? []),
      isAvailable: data['isAvailable'] ?? false,
      calories: data['calories'] ?? '',
      menuTags: List<String>.from(data['menuTags'] ?? []),
      dietaryTags: List<String>.from(data['dietaryTags'] ?? []),
    );
  }
}
