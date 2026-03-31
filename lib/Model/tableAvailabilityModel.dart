import 'package:cloud_firestore/cloud_firestore.dart';

class TableAvailability {
  final String id; //eg. '2026-04-01_table1'
  final String date;// 'YYYY-MM-DD'
  final String tableId;
  final List<String> availableSlots;

  TableAvailability({
    required this.id,
    required this.date,
    required this.tableId,
    required this.availableSlots,
  });

  factory TableAvailability.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return TableAvailability(
      id: documentId,
      date: data['date'] ?? '',
      tableId: data['tableId'] ?? '',
      availableSlots: List<String>.from(data['availableSlots'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'tableId': tableId, 'availableSlots': availableSlots};
  }
}
