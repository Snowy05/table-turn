import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingFormModel extends ChangeNotifier {
  DateTime? selectedDate;
  String? selectedTable;
  String? selectedSlot;
  int duration = 1;
  int guests = 1;
  String? selectedBoardgame;
  String specialRequests = '';

  //load from shared preferences
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('booking_selectedDate');
    selectedDate = dateStr != null ? DateTime.tryParse(dateStr) : null;
    selectedTable = prefs.getString('booking_selectedTable');
    selectedSlot = prefs.getString('booking_selectedSlot');
    duration = prefs.getInt('booking_duration') ?? 1;
    guests = prefs.getInt('booking_guests') ?? 1;
    selectedBoardgame = prefs.getString('booking_selectedBoardgame');
    specialRequests = prefs.getString('booking_specialRequests') ?? '';
    notifyListeners();
  }

  //vve to shared preferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    if (selectedDate != null) {
      prefs.setString('booking_selectedDate', selectedDate!.toIso8601String());
    }
    if (selectedTable != null) {
      prefs.setString('booking_selectedTable', selectedTable!);
    }
    if (selectedSlot != null) {
      prefs.setString('booking_selectedSlot', selectedSlot!);
    }
    prefs.setInt('booking_duration', duration);
    prefs.setInt('booking_guests', guests);
    if (selectedBoardgame != null) {
      prefs.setString('booking_selectedBoardgame', selectedBoardgame!);
    }
    prefs.setString('booking_specialRequests', specialRequests);
  }

  //clear all booking data
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('booking_selectedDate');
    await prefs.remove('booking_selectedTable');
    await prefs.remove('booking_selectedSlot');
    await prefs.remove('booking_duration');
    await prefs.remove('booking_guests');
    await prefs.remove('booking_selectedBoardgame');
    await prefs.remove('booking_specialRequests');
    selectedDate = null;
    selectedTable = null;
    selectedSlot = null;
    duration = 1;
    guests = 1;
    selectedBoardgame = null;
    specialRequests = '';
    notifyListeners();
  }

  //setters that notify and save
  void setSelectedDate(DateTime? date) {
    selectedDate = date;
    save();
    notifyListeners();
  }

  void setSelectedTable(String? table) {
    selectedTable = table;
    save();
    notifyListeners();
  }

  void setSelectedSlot(String? slot) {
    selectedSlot = slot;
    save();
    notifyListeners();
  }

  void setDuration(int d) {
    duration = d;
    save();
    notifyListeners();
  }

  void setGuests(int g) {
    guests = g;
    save();
    notifyListeners();
  }

  void setSelectedBoardgame(String? game) {
    selectedBoardgame = game;
    save();
    notifyListeners();
  }

  void setSpecialRequests(String s) {
    specialRequests = s;
    save();
    notifyListeners();
  }
}
