import 'package:flutter/material.dart';
import 'package:tableturn_project0/Controller/BookingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tableturn_project0/Controller/TableAvailabilityService.dart';
import 'package:tableturn_project0/Model/bookingModel.dart';
import 'package:tableturn_project0/View/Booking/SlotPickerModal.dart';
import 'package:tableturn_project0/Widgets/BottomNav.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedDate = DateTime.now(); // default to today
  String? _selectedTable = 'table1'; // default to first table
  String? _selectedSlot; 
  int _duration = 1; // default duration in hours
  int _guests = 1; // default number of guests
  String? _selectedBoardgame = 'None'; // for game selection, if needed, as of now selected none
  final TextEditingController _specialRequestsController =
      TextEditingController();
 // This function will get the slots needed for the booking duration, e.g., if the user selects 12:00 and a duration of 3 hours, it will return ['12:00', '14:00', '16:00']
  List<String> getSlotsForDuration(String startSlot, int duration) {
  final slotTimes = defaultSlots;
  final startIdx = slotTimes.indexOf(startSlot);
  if (startIdx == -1) return [];
  // Collect slots for the duration (e.g., 10:00, 12:00, 14:00 for 3 hours)
  return slotTimes.skip(startIdx).take(duration).toList();
}

  Future<void> _submitBooking() async {
  if (_selectedDate == null || _selectedTable == null || _selectedSlot == null) return;

  final dateStr = _selectedDate!.toIso8601String().split('T')[0]; // T is used to split date and time, we only need the date part for fetching availability
  final availableSlots = await Tableavailabilityservice().getAvailableSlots(dateStr, _selectedTable!);

  // Get all slots needed for the booking duration
  final slotsNeeded = getSlotsForDuration(_selectedSlot!, _duration);

  // Check if all slots are available
  final allAvailable = slotsNeeded.every((slot) => availableSlots.contains(slot));
  if (!allAvailable) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sorry, one or more slots in your booking duration are no longer available.')),
    );
    return;
  }

    // Check slot availability before booking
    if (!availableSlots.contains(_selectedSlot)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorry, this slot is no longer available.')),
      );
      return;
    }

    // Build booking start/end time
    final bookingStart = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      int.parse(_selectedSlot!.split(':')[0]),
      int.parse(_selectedSlot!.split(':')[1]),
    );
    final bookingEnd = bookingStart.add(Duration(hours: _duration));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('You must be logged in to book.')));
      return;
    }
    final booking = BookingModel(
      uid: '',
      userId: user.uid,
      tableId: _selectedTable!,
      boardGameId: _selectedBoardgame ?? '',
      bookingStartTime: bookingStart,
      bookingEndTime: bookingEnd,
      numberOfPeople: _guests,
      specialRequests: _specialRequestsController.text,
      status: 'pending',
      createdAt: DateTime.now(),
    );

   try {
    await BookingService().createBooking(booking);
    // Remove all slots covered by the booking
    for (final slot in slotsNeeded) {
      await Tableavailabilityservice().bookSlot(dateStr, _selectedTable!, slot);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking successful!')),
    );
    // Optionally reset form or navigate away
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking failed: $e')),
    );
  }
}
  // slotpicker modal here
  void _showSlotPicker() async {
    if (_selectedTable == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date and table first!')),
      );
      return;
    }
    String? picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SlotPickerModal(slots: defaultSlots),
    );
    if (picked != null) setState(() => _selectedSlot = picked);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date'),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Text(
                _selectedDate == null
                    ? 'Choose Date'
                    : _selectedDate!.toLocal().toString().split(' ')[0],
              ),
            ),
            SizedBox(height: 20),
            Text('Select Table'),
            DropdownButton<String>(
              value: _selectedTable,
              hint: Text('Choose Table'),
              items: ['table1', 'table2', 'table3', 'table4', 'table5']
                  .map(
                    (table) =>
                        DropdownMenuItem(value: table, child: Text(table)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedTable = val),
            ),
            SizedBox(height: 20),
            Text('Select Time Slot'),
            ElevatedButton(
              onPressed: () {
                _showSlotPicker();
              },
              child: Text(_selectedSlot ?? 'Slot'),
            ),

            SizedBox(height: 20),
            // Duration and guests selection
            Text('Duration (hours)'),
            DropdownButton(
              value: _duration,
              items: [1, 2, 3, 4, 5]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _duration = val);
              },
            ),
            SizedBox(height: 10),

            // Number of Guests
            Text('Number of Guests'),
            DropdownButton<int>(
              value: _guests,
              items: List.generate(12, (i) => i + 1)
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _guests = val);
              },
            ),
            SizedBox(height: 16),

            // Boardgame (placeholder for now)
            Text('Boardgame (optional)'),
            DropdownButton<String>(
              value: _selectedBoardgame,
              hint: Text('Choose Boardgame'),
              items: ['None', 'Catan', 'Chess', 'Monopoly']
                  .map(
                    (game) => DropdownMenuItem(value: game, child: Text(game)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedBoardgame = val),
            ),
            SizedBox(height: 16),

            // Special Requests
            Text('Special Requests'),
            TextField(
              controller: _specialRequestsController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Any special requests?',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed:
                  (_selectedDate != null &&
                      _selectedTable != null &&
                      _selectedSlot != null)
                  ? _submitBooking
                  : null,
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/bookings');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
