class GameModel {
  // Identifiers
  final String uid;
  final String gameName;

  // Player info
  final int minPlayers;
  final int maxPlayers;

  /// Player tag string for filtering (e.g., '2p', '3-4p', '5p+')
  String get playerTag {
    if (minPlayers == maxPlayers) {
      return '${minPlayers}p';
    } else if (minPlayers == 2 && maxPlayers == 2) {
      return '2p';
    } else if (minPlayers == 3 && maxPlayers == 4) {
      return '3-4p';
    } else if (maxPlayers >= 5) {
      return '5p+';
    } else {
      return '2${minPlayers}-${maxPlayers}p';
    }
  }

  // core info
  final String description;
  final String imageAsset; // Local asset path
  final String imageUrl; // Network image URL

  // Filtering fields
  final List<String> ageGroups;
  final String complexity;
  final List<String> playTimes;
  final List<String> tags;

  // Tutorial/rules
  final String tutorial;

  // Status and stock
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
    required this.imageAsset,
    required this.imageUrl,
    required this.ageGroups,
    required this.complexity,
    required this.playTimes,
    required this.tags,
    required this.tutorial,
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
      imageAsset: data['imageAsset'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      ageGroups: List<String>.from(data['ageGroups'] ?? []),
      complexity: data['complexity'] ?? '',
      playTimes: List<String>.from(data['playTimes'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      tutorial: data['tutorial'] ?? '',
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
      'imageAsset': imageAsset,
      'imageUrl': imageUrl,
      'ageGroups': ageGroups,
      'complexity': complexity,
      'playTimes': playTimes,
      'tags': tags,
      'tutorial': tutorial,
      'isAvailable': isAvailable,
      'isAvailableForBooking': isAvailableForBooking,
      'availabilityStatus': availabilityStatus,
      'quantityInStock': quantityInStock,
    };
  }
}
