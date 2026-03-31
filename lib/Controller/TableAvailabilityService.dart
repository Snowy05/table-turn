import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/tableAvailabilityModel.dart';

//def table id and time for availability in case no document exists for that date and table

const List<String> defaultTableIds = [
  'table1',
  'table2',
  'table3',
  'table4',
  'table5',
];
const List<String> defaultSlots = [
  '10:00',
  '12:00',
  '14:00',
  '16:00',
  '18:00',
  '20:00',
  '22:00',
];

class Tableavailabilityservice {
  //get available slots for date and table 
  Future<List<String>> getAvailableSlots(String date, String tableId) async {
    final docId = '${date}_$tableId';
    final doc = await FirebaseFirestore.instance
        .collection('availability')
        .doc(docId)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      return List<String>.from(data['availableSlots'] ?? '');
    } else {
      return defaultSlots;
    }
  }
//book a slot for a date and table, this will remove the slot from the available slots for that date and table
  Future<void> bookSlot(String date, String tableId, String slot) async{
    final docId = '${date}_${tableId}';
    final docRef = FirebaseFirestore.instance.collection('availability').doc(docId);
    final doc = await docRef.get();

    if (doc.exists){
      await docRef.update({
        'availableSlots': FieldValue.arrayRemove([slot])
      });
       }
       else{
        final newSlot = List<String>.from(defaultSlots)..remove(slot);
        await docRef.set({
          'date': date,
          'tableId': tableId,
          'availableSlots': newSlot
        });
       }
    }
  }

