import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String phoneNumber;
  final String age;
  final List<String> favouriteGames;
  final int loyaltyPoints;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.age,
    required this.favouriteGames,
    required this.loyaltyPoints,
    required this.createdAt,
  });

  //constructor to create user from firestore document

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId){
    return AppUser(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      age: data['age'] ?? '',
      favouriteGames: List<String>.from(data['favouriteGames'] ?? []),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
//converting user from firestore data
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'age': age,
      'favouriteGames': favouriteGames,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': createdAt,
    };
  }
}
