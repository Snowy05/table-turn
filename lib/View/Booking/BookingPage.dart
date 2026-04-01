import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tableturn_project0/Controller/BookingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tableturn_project0/Controller/TableAvailabilityService.dart'
    as table_availability;
import 'package:tableturn_project0/Model/Options/constants.dart'
    as options_constants;
import 'package:tableturn_project0/Model/bookingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tableturn_project0/Model/gameModel.dart';
import 'package:tableturn_project0/View/Booking/SlotPickerModal.dart';
import 'package:tableturn_project0/Widgets/BottomNav.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Map<DateTime, double> _fullnessByDay = {};
  bool _loadingFullness = false;

  Future<void> _fetchFullnessForNextWeek() async {
    setState(() {
      _loadingFullness = true;
    });
    final Map<DateTime, double> result = {};
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day + i);
      final dateStr = day.toIso8601String().split('T')[0];
      final availableSlots = await table_availability.Tableavailabilityservice()
          .getAvailableSlots(dateStr, _selectedTable ?? 'table1');
      final booked =
          options_constants.defaultSlots.length - availableSlots.length;
      final fullness = booked / options_constants.defaultSlots.length;
      result[DateTime(day.year, day.month, day.day)] = fullness;
    }
    setState(() {
      _fullnessByDay = result;
      _loadingFullness = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAvailableBoardgames();
    _fetchFullnessForNextWeek();
  }

  DateTime? _selectedDate = DateTime.now(); // default to today
  String? _selectedTable = 'table1'; // default to first table
  String? _selectedSlot;
  int _duration = 1; // default duration in hours
  int _guests = 1; // default number of guests
  String? _selectedBoardgame =
      'None'; // for game selection, if needed, as of now selected none
  final TextEditingController _specialRequestsController =
      TextEditingController();
  List<GameModel> _availableBoardgames = [];
  bool _loadingBoardgames = false;

  // Fetch available boardgames from Firestore
  Future<void> _fetchAvailableBoardgames() async {
    setState(() {
      _loadingBoardgames = true;
    });
    final snapshot = await FirebaseFirestore.instance
        .collection('boardgames')
        .where('isAvailableForBooking', isEqualTo: true)
        .get();
    final games = snapshot.docs
        .map((doc) => GameModel.fromMap(doc.data(), doc.id))
        .toList();
    setState(() {
      _availableBoardgames = games;
      _loadingBoardgames = false;
    });
  }

  //this function will get the slots needed for the booking duration, e.g., if the user selects 12:00 and a duration of 3 hours, it will return ['12:00', '14:00', '16:00']
  List<String> getSlotsForDuration(String startSlot, int duration) {
    final slotTimes = options_constants.defaultSlots;
    final startIdx = slotTimes.indexOf(startSlot);
    if (startIdx == -1) return [];
    //collect slots for the duration (e.g., 10:00, 12:00, 14:00 for 3 hours)
    return slotTimes.skip(startIdx).take(duration).toList();
  }

  Future<void> _submitBooking() async {
    if (_selectedDate == null ||
        _selectedTable == null ||
        _selectedSlot == null)
      return;

    final dateStr = _selectedDate!.toIso8601String().split(
      'T',
    )[0]; //rT is used to split date and time, we only need the date part for fetching availability
    final availableSlots = await table_availability.Tableavailabilityservice()
        .getAvailableSlots(dateStr, _selectedTable!);

    //get all slots needed for the booking duration
    final slotsNeeded = getSlotsForDuration(_selectedSlot!, _duration);

    //gcheck if all slots are available
    final allAvailable = slotsNeeded.every(
      (slot) => availableSlots.contains(slot),
    );
    if (!allAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sorry, one or more slots in your booking duration are no longer available.',
          ),
        ),
      );
      return;
    }

    //Check slot availability before booking
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
        await table_availability.Tableavailabilityservice().bookSlot(
          dateStr,
          _selectedTable!,
          slot,
        );
      }
      //ecrease boardgame quantity if one is selected
      if (_selectedBoardgame != null && _selectedBoardgame != 'None') {
        final gameRef = FirebaseFirestore.instance
            .collection('boardgames')
            .doc(_selectedBoardgame);
        await gameRef.update({'quantityInStock': FieldValue.increment(-1)});
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking successful!')));
      // Optionally reset form or navigate away
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking failed: $e')));
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
    final dateStr = _selectedDate!.toIso8601String().split('T')[0];
    final availableSlots = await table_availability.Tableavailabilityservice()
        .getAvailableSlots(dateStr, _selectedTable!);

    String? picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SlotPickerModal(slots: availableSlots),
    );
    if (picked != null) setState(() => _selectedSlot = picked);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date selection with fullness indicators (0-50% green, 50-100% orange, 100% red)
              _loadingFullness
                  ? Center(child: CircularProgressIndicator())
                  : TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(Duration(days: 14)),
                      focusedDay: _selectedDate ?? DateTime.now(),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      calendarFormat: CalendarFormat.twoWeeks,
                      availableCalendarFormats: const {
                        CalendarFormat.twoWeeks: 'Two Weeks',
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                        });
                      },
                      selectedDayPredicate: (day) =>
                          isSameDay(day, _selectedDate),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) { //color code days based on fullness
                          final key = DateTime(day.year, day.month, day.day);// normalize to date only for lookup
                          final fullness = _fullnessByDay[key] ?? 0.0;
                          Color bg;
                          if (fullness >= 0.8) { // 80% or more booked
                            bg = Colors.red;
                          } else if (fullness >= 0.5) { // 50-80% booked
                            bg = Colors.orange;
                          } else {
                            bg = Colors.green; // less than 50% booked
                          }
                          return Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              // SizedBox(height: 20),
              // Text('Select Date'),
              // ElevatedButton(
              //   onPressed: () async {
              //     DateTime? picked = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime.now(),
              //       firstDate: DateTime.now(),
              //       lastDate: DateTime.now().add(Duration(days: 365)),
              //     );
              //     if (picked != null) setState(() => _selectedDate = picked);
              //   },
              //   child: Text(
              //     _selectedDate == null
              //         ? 'Choose Date'
              //         : _selectedDate!.toLocal().toString().split(' ')[0],
              //   ),
              // ),
              
              
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

              // Boardgame (from Firestore, only available for booking and the quantity in stock is greater than 0)
              Text('Boardgame (optional)'),
              _loadingBoardgames
                  ? CircularProgressIndicator()
                  : DropdownButton<String>(
                      value: _selectedBoardgame,
                      hint: Text('Choose Boardgame'),
                      items: [
                        DropdownMenuItem(value: 'None', child: Text('None')),
                        ..._availableBoardgames.map(
                          (game) => DropdownMenuItem(
                            value: game.uid,
                            child: Text(
                              '${game.gameName} (${game.quantityInStock})',
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedBoardgame = val),
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
