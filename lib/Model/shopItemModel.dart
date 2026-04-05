class ShopItem {
  final String id;
  final String name;
  final String assetPath;
  final int price;
  final String description;

  ShopItem({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.price,
    required this.description,
  });

  factory ShopItem.fromMap(Map<String, dynamic> data, String documentId) {
    return ShopItem(
      id: documentId,
      name: data['name'] ?? '',
      assetPath: data['assetPath'] ?? '',
      price: data['price'] ?? 0,
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'assetPath': assetPath,
      'price': price,
      'description': description,
    };
  }
}
