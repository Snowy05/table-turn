class GameModel {
  final String uid;
  final String gameName;
  final int minPlayers;
  final int maxPlayers;
  final String description;
  final List<String> categories;
  final List<String> ageGroups;
  final String imageUrl;
  final String complexity;
  final List<String> playTimes;
  final List<String> tags;
  final bool isAvailable;
  final bool isAvailableForBooking;
  final String availabilityStatus;
  final int quantityInStock;

  GameModel({
    required this.uid,
    required this.gameName,
    required this.minPlayers,
    required this.maxPlayers,
    required this.description,
    required this.categories,
    required this.ageGroups,
    required this.imageUrl,
    required this.complexity,
    required this.playTimes,
    required this.tags,
    required this.isAvailable,
    required this.isAvailableForBooking,
    required this.availabilityStatus,
    required this.quantityInStock,
  });

  factory GameModel.fromMap(Map<String, dynamic> data, String documentId) {
    return GameModel(
      uid: documentId,
      gameName: data['gameName'] ?? '',
      minPlayers: data['minPlayers'] ?? 2,
      maxPlayers: data['maxPlayers'] ?? 2,
      description: data['description'] ?? '',
      categories: List<String>.from(data['categories'] ?? []),
      ageGroups: List<String>.from(data['ageGroups'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      complexity: data['complexity'] ?? '',
      playTimes: List<String>.from(data['playTimes'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      isAvailable: data['isAvailable'] ?? false,
      isAvailableForBooking: data['isAvailableForBooking'] ?? false,
      availabilityStatus: data['availabilityStatus'] ?? 'unavailable',
      quantityInStock: data['quantityInStock'] ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'gameName': gameName,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'description': description,
      'categories': categories,
      'ageGroups': ageGroups,
      'imageUrl': imageUrl,
      'complexity': complexity,
      'playTimes': playTimes,
      'tags': tags,
      'isAvailable': isAvailable,
      'isAvailableForBooking': isAvailableForBooking,
      'availabilityStatus': availabilityStatus,
      'quantityInStock': quantityInStock,
    };
  }
}
