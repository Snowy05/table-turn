import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/shopItemModel.dart';

class ShopItemsService {
  final CollectionReference _shopItemsCollection = FirebaseFirestore.instance
      .collection('shopItems');

  //fetch all shop items (real-time updates)
  Stream<List<ShopItem>> shopItemsStream() {
    return _shopItemsCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                ShopItem.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList(),
    );
  }

  //dne-time fetch
  Future<List<ShopItem>> fetchShopItems() async {
    final snapshot = await _shopItemsCollection.get();
    return snapshot.docs
        .map(
          (doc) => ShopItem.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  //Add a new shop item
  Future<void> addShopItem(ShopItem item) async {
    await _shopItemsCollection.add(item.toMap());
  }

  //update an existing shop item
  Future<void> updateShopItem(ShopItem item) async {
    await _shopItemsCollection.doc(item.id).update(item.toMap());
  }

  //delete a shop item
  Future<void> deleteShopItem(String id) async {
    await _shopItemsCollection.doc(id).delete();
  }
}
