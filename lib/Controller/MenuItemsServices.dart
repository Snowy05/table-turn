import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/menuItemModel.dart';

class MenuItemsService {
  final CollectionReference _menuItemsCollection = FirebaseFirestore.instance
      .collection('menuItems');

  Future<List<MenuItemModel>> fetchMenuItems() async {
    final snapshot = await _menuItemsCollection.get();
    return snapshot.docs
        .map(
          (doc) =>
              MenuItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<MenuItemModel?> getMenuItemById(String id) async {
    final doc = await _menuItemsCollection.doc(id).get();
    if (doc.exists) {
      return MenuItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
// Admin functions to add, update and delete menu items
  Future<void> addMenuItem(MenuItemModel item) async {
    await _menuItemsCollection.doc(item.uid).set({
      'name': item.name,
      'description': item.description,
      'price': item.price,
      'imageUrl': item.imageUrl,
      'category': item.category,
      'isAvailable': item.isAvailable,
      'calories': item.calories,
      'menuTags': item.menuTags,
      'dietaryTags': item.dietaryTags,
    });
  }
// for later use, this will update the menu item with the given id, it will replace all fields with the new values, so make sure to pass all fields when updating, otherwise they will be set to default values
  Future<void> updateMenuItem(MenuItemModel item) async {
    await _menuItemsCollection.doc(item.uid).update({
      'name': item.name,
      'description': item.description,
      'price': item.price,
      'imageUrl': item.imageUrl,
      'category': item.category,
      'isAvailable': item.isAvailable,
      'calories': item.calories,
      'menuTags': item.menuTags,
      'dietaryTags': item.dietaryTags,
    });
  }

  Future<void> deleteMenuItem(String id) async {
    await _menuItemsCollection.doc(id).delete();
  }
}
