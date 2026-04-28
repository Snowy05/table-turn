import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:tableturn_project0/Controller/BookingHelpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tableturn_project0/Controller/TableAvailabilityService.dart'
    as table_availability;
import 'package:tableturn_project0/Model/bookingModel.dart';
import 'package:tableturn_project0/Model/gameModel.dart';
import 'package:provider/provider.dart';
import 'package:tableturn_project0/Model/bookingFormModel.dart';
import 'package:tableturn_project0/View/Booking/BookingButton.dart';
import 'package:tableturn_project0/View/Booking/SlotPickerModal.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/GlobalWidgets/FriendlyMessageDialog.dart';
import 'package:tableturn_project0/GlobalWidgets/GlobalDropdownField.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  static const int _lastStepIndex = 3;
  bool _hasInitializedFormBindings = false;
  String? _lastLoadedTable;

  Widget _stepperControlsBuilder(
    BuildContext context,
    ControlsDetails details,
  ) {
    return Row(
      children: [
        Expanded(
          child: BookingButton(
            label: _currentStep == _lastStepIndex
                ? 'Pay & Book Now'
                : 'Continue',
            onPressed: details.onStepContinue ?? () {},
          ),
        ),
        const SizedBox(width: 12),
        if (_currentStep > 0)
          Expanded(
            child: BookingButton(
              label: 'Cancel',
              onPressed: details.onStepCancel ?? () {},
              color: Colors.grey,
              textStyle: const TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }

  int _currentStep = 0;
  Map<DateTime, double> _fullnessByDay = {};
  bool _loadingFullness = false;
  List<GameModel> _availableBoardgames = [];
  bool _loadingBoardgames = false;
  final TextEditingController _specialRequestsController =
      TextEditingController();

  void _syncSpecialRequestsToForm() {
    final bookingForm = Provider.of<BookingFormModel>(context, listen: false);
    bookingForm.setSpecialRequests(_specialRequestsController.text);
  }

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
    final bookingForm = Provider.of<BookingFormModel>(context, listen: false);

    if (!_hasInitializedFormBindings) {
      _specialRequestsController.text = bookingForm.specialRequests;
      _specialRequestsController.addListener(_syncSpecialRequestsToForm);
      _hasInitializedFormBindings = true;
      _lastLoadedTable = bookingForm.selectedTable;
      _fetchFullnessForNextWeek(context);
      return;
    }

    if (_specialRequestsController.text != bookingForm.specialRequests) {
      _specialRequestsController.text = bookingForm.specialRequests;
    }

    if (_lastLoadedTable != bookingForm.selectedTable) {
      _lastLoadedTable = bookingForm.selectedTable;
      _fetchFullnessForNextWeek(context);
    }
  }

  @override
  void dispose() {
    _specialRequestsController.removeListener(_syncSpecialRequestsToForm);
    _specialRequestsController.dispose();
    super.dispose();
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

  String _formatBookingDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  bool _hasBookedBoardGame(String? boardGameId) {
    return boardGameId != null &&
        boardGameId.isNotEmpty &&
        boardGameId != 'None';
  }

  Future<void> _showBookingSuccessDialog({
    required DateTime bookingDate,
    required bool hasBoardGame,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return FriendlyMessageDialog(
          title: 'Booking Confirmed',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
          secondaryActionLabel: 'Close',
          onSecondaryPressed: () => Navigator.of(dialogContext).pop(),
          primaryActionLabel: 'My Bookings',
          onPrimaryPressed: () {
            Navigator.of(dialogContext).pop();
            Navigator.pushNamed(context, '/mybookings');
          },
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You have successfully booked for'),
              const SizedBox(height: 10),
              Text(
                _formatBookingDate(bookingDate),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (hasBoardGame) ...[
                const SizedBox(height: 14),
                const Text(
                  'If you booked a game, please ask our colleague in the cafe for it!',
                ),
              ],
              const SizedBox(height: 14),
              const Text(
                'For your booking details please go to the "My Bookings" page!',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitBooking(BuildContext context) async {
    final bookingForm = Provider.of<BookingFormModel>(context, listen: false);
    if (bookingForm.selectedDate == null ||
        bookingForm.selectedTable == null ||
        bookingForm.selectedSlot == null)
      return;
    // check availability for all slots needed for the duration
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
    final bookingDate = bookingForm.selectedDate!;
    final hasBoardGame = _hasBookedBoardGame(bookingForm.selectedBoardgame);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('You must be logged in to book.')));
      return;
    }
    // Create booking model when validated
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
      await bookingForm.clear();
      _specialRequestsController.clear();
      if (!mounted) return;
      setState(() {
        _currentStep = 0;
      });
      await _showBookingSuccessDialog(
        bookingDate: bookingDate,
        hasBoardGame: hasBoardGame,
      );
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFFFE8DC)],
          ),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < _lastStepIndex) {
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
          controlsBuilder: _stepperControlsBuilder,
          steps: [
            Step(
              title: Text(''),
              isActive: _currentStep >= 0,
              content: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _loadingFullness
                        ? Center(child: CircularProgressIndicator())
                        : Builder(
                            builder: (context) {
                              final firstDay = DateTime.now();
                              final lastDay = DateTime.now().add(
                                Duration(days: 14),
                              );
                              DateTime focusedDay =
                                  bookingForm.selectedDate ?? DateTime.now();
                              if (focusedDay.isBefore(firstDay))
                                focusedDay = firstDay;
                              return TableCalendar(
                                firstDay: firstDay,
                                lastDay: lastDay,
                                focusedDay: focusedDay,
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                ),
                                calendarFormat: CalendarFormat.twoWeeks,
                                availableCalendarFormats: const {
                                  CalendarFormat.twoWeeks: 'Two Weeks',
                                },
                                onDaySelected: (selectedDay, newFocusedDay) {
                                  bookingForm.setSelectedDate(selectedDay);
                                },
                                selectedDayPredicate: (day) =>
                                    isSameDay(day, bookingForm.selectedDate),
                                calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, day, focusedDay) {
                                    final key = DateTime(
                                      day.year,
                                      day.month,
                                      day.day,
                                    );
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
                              );
                            },
                          ),
                    SizedBox(height: 32),
                    Text('Select Table'),
                    SizedBox(height: 12),
                    GlobalDropdownField<String>(
                      value: bookingForm.selectedTable,
                      hintText: 'Choose Table',
                      maxWidth: 220,
                      items: ['table1', 'table2', 'table3', 'table4', 'table5']
                          .map((table) {
                            final tableNumber = table.replaceAll('table', '');
                            return DropdownMenuItem(
                              value: table,
                              child: Text('Table $tableNumber'),
                            );
                          })
                          .toList(),
                      onChanged: (val) => bookingForm.setSelectedTable(val),
                    ),
                    SizedBox(height: 32),
                    Text('Select Time Slot'),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        _showSlotPicker(context);
                      },
                      child: Text(bookingForm.selectedSlot ?? 'Slot'),
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: Text(''),
              isActive: _currentStep >= 1,
              content: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Duration (hours)'),
                    SizedBox(height: 12),
                    GlobalDropdownField<int>(
                      value: bookingForm.duration,
                      hintText: 'Choose duration',
                      maxWidth: 180,
                      items: [1, 2, 3, 4, 5]
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text('$e')),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) bookingForm.setDuration(val);
                      },
                    ),
                    SizedBox(height: 24),
                    Text('Number of Guests'),
                    SizedBox(height: 12),
                    GlobalDropdownField<int>(
                      value: bookingForm.guests,
                      hintText: 'Choose guests',
                      maxWidth: 180,
                      items: List.generate(12, (i) => i + 1)
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text('$e')),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) bookingForm.setGuests(val);
                      },
                    ),
                  ],
                ),
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
                      : GlobalDropdownField<String>(
                          value: bookingForm.selectedBoardgame ?? 'None',
                          hintText: 'Choose Boardgame',
                          maxWidth: 320,
                          items: [
                            const DropdownMenuItem(
                              value: 'None',
                              child: Text('None'),
                            ),
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
                  SizedBox(height: 32),
                  Text('Special Requests'),
                  SizedBox(height: 12),
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
              isActive: _currentStep >= _lastStepIndex,
              content: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Review your booking details, then press "Pay & Book Now" below to confirm.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
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
