import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tableturn_project0/Controller/BookingService.dart';
import 'package:tableturn_project0/Controller/BookingHelpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tableturn_project0/Controller/TableAvailabilityService.dart'
    as table_availability;
import 'package:tableturn_project0/Model/Options/constants.dart'
    as options_constants;
import 'package:tableturn_project0/Model/bookingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tableturn_project0/Model/gameModel.dart';
import 'package:provider/provider.dart';
import 'package:tableturn_project0/Model/bookingFormModel.dart';
import 'package:tableturn_project0/View/Booking/SlotPickerModal.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _currentStep = 0;
  Map<DateTime, double> _fullnessByDay = {};
  bool _loadingFullness = false;
  List<GameModel> _availableBoardgames = [];
  bool _loadingBoardgames = false;
  final TextEditingController _specialRequestsController =
      TextEditingController();

  Future<void> _fetchFullnessForNextWeek(BuildContext context) async {
    setState(() {
      _loadingFullness = true;
    });
    final bookingForm = Provider.of<BookingFormModel>(context, listen: false);
    final result = await BookingHelpers.fetchFullnessForNextWeek(
      bookingForm.selectedTable,
    );
    setState(() {
      _fullnessByDay = result;
      _loadingFullness = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAvailableBoardgames();
    // Fullness fetch moved to didChangeDependencies to ensure Provider is available
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchFullnessForNextWeek(context);
    final bookingForm = Provider.of<BookingFormModel>(context, listen: false);
    _specialRequestsController.text = bookingForm.specialRequests;
    _specialRequestsController.addListener(() {
      bookingForm.setSpecialRequests(_specialRequestsController.text);
    });
  }

  // Fetch available boardgames from Firestore
  Future<void> _fetchAvailableBoardgames() async {
    setState(() {
      _loadingBoardgames = true;
    });
    final games = await BookingHelpers.fetchAvailableBoardgames();
    setState(() {
      _availableBoardgames = games;
      _loadingBoardgames = false;
    });
  }

  //this function will get the slots needed for the booking duration, e.g., if the user selects 12:00 and a duration of 3 hours, it will return ['12:00', '14:00', '16:00']
  List<String> getSlotsForDuration(String startSlot, int duration) {
    return BookingHelpers.getSlotsForDuration(startSlot, duration);
  }

  Future<void> _submitBooking(BuildContext context) async {
    final bookingForm = Provider.of<BookingFormModel>(context, listen: false);
    if (bookingForm.selectedDate == null ||
        bookingForm.selectedTable == null ||
        bookingForm.selectedSlot == null)
      return;

    final dateStr = bookingForm.selectedDate!.toIso8601String().split('T')[0];
    final availableSlots = await table_availability.Tableavailabilityservice()
        .getAvailableSlots(dateStr, bookingForm.selectedTable!);

    final slotsNeeded = BookingHelpers.getSlotsForDuration(
      bookingForm.selectedSlot!,
      bookingForm.duration,
    );
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

    if (!availableSlots.contains(bookingForm.selectedSlot)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorry, this slot is no longer available.')),
      );
      return;
    }

    final bookingStart = DateTime(
      bookingForm.selectedDate!.year,
      bookingForm.selectedDate!.month,
      bookingForm.selectedDate!.day,
      int.parse(bookingForm.selectedSlot!.split(':')[0]),
      int.parse(bookingForm.selectedSlot!.split(':')[1]),
    );
    final bookingEnd = bookingStart.add(Duration(hours: bookingForm.duration));

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
      tableId: bookingForm.selectedTable!,
      boardGameId: bookingForm.selectedBoardgame ?? '',
      bookingStartTime: bookingStart,
      bookingEndTime: bookingEnd,
      numberOfPeople: bookingForm.guests,
      specialRequests: bookingForm.specialRequests,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    final error = await BookingHelpers.submitBooking(
      booking: booking,
      slotsNeeded: slotsNeeded,
      dateStr: dateStr,
      tableId: bookingForm.selectedTable!,
      boardGameId: bookingForm.selectedBoardgame,
    );
    if (error == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking successful!')));
      await bookingForm.clear();
      _specialRequestsController.clear();
      setState(() {
        _currentStep = 0;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking failed: $error')));
    }
  }

  // slotpicker modal here
  void _showSlotPicker(BuildContext context) async {
    final bookingForm = Provider.of<BookingFormModel>(context, listen: false);
    if (bookingForm.selectedTable == null || bookingForm.selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date and table first!')),
      );
      return;
    }
    final dateStr = bookingForm.selectedDate!.toIso8601String().split('T')[0];
    final availableSlots = await table_availability.Tableavailabilityservice()
        .getAvailableSlots(dateStr, bookingForm.selectedTable!);

    String? picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SlotPickerModal(slots: availableSlots),
    );
    if (picked != null) bookingForm.setSelectedSlot(picked);
  }

  Widget build(BuildContext context) {
    final bookingForm = Provider.of<BookingFormModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Booking Page')),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep++);
          } else {
            _submitBooking(context);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: Text(''),
            isActive: _currentStep >= 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _loadingFullness
                    ? Center(child: CircularProgressIndicator())
                    : TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(Duration(days: 14)),
                        focusedDay: bookingForm.selectedDate ?? DateTime.now(),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarFormat: CalendarFormat.twoWeeks,
                        availableCalendarFormats: const {
                          CalendarFormat.twoWeeks: 'Two Weeks',
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          bookingForm.setSelectedDate(selectedDay);
                        },
                        selectedDayPredicate: (day) =>
                            isSameDay(day, bookingForm.selectedDate),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final key = DateTime(day.year, day.month, day.day);
                            final fullness = _fullnessByDay[key] ?? 0.0;
                            Color bg;
                            if (fullness >= 0.8) {
                              bg = Colors.red;
                            } else if (fullness >= 0.5) {
                              bg = Colors.orange;
                            } else {
                              bg = Colors.green;
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
                SizedBox(height: 20),
                Text('Select Table'),
                DropdownButton<String>(
                  value: bookingForm.selectedTable,
                  hint: Text('Choose Table'),
                  items: ['table1', 'table2', 'table3', 'table4', 'table5']
                      .map(
                        (table) =>
                            DropdownMenuItem(value: table, child: Text(table)),
                      )
                      .toList(),
                  onChanged: (val) => bookingForm.setSelectedTable(val),
                ),
                SizedBox(height: 20),
                Text('Select Time Slot'),
                ElevatedButton(
                  onPressed: () {
                    _showSlotPicker(context);
                  },
                  child: Text(bookingForm.selectedSlot ?? 'Slot'),
                ),
              ],
            ),
          ),
          Step(
            title: Text(''),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duration (hours)'),
                DropdownButton<int>(
                  value: bookingForm.duration,
                  items: [1, 2, 3, 4, 5]
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) bookingForm.setDuration(val);
                  },
                ),
                SizedBox(height: 10),
                Text('Number of Guests'),
                DropdownButton<int>(
                  value: bookingForm.guests,
                  items: List.generate(12, (i) => i + 1)
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) bookingForm.setGuests(val);
                  },
                ),
              ],
            ),
          ),
          Step(
            title: Text(''),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Boardgame (optional)'),
                _loadingBoardgames
                    ? CircularProgressIndicator()
                    : DropdownButton<String>(
                        value: bookingForm.selectedBoardgame ?? 'None',
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
                            bookingForm.setSelectedBoardgame(val),
                      ),
                SizedBox(height: 16),
                Text('Special Requests'),
                TextField(
                  controller: _specialRequestsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Any special requests?',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Step(
            title: Text(''),
            isActive: _currentStep >= 3,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mock Payment Step'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _submitBooking(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mock payment successful!')),
                    );
                  },
                  child: Text('Pay & Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/loyalty');
              break;
          }
        },
      ),
    );
  }
}
