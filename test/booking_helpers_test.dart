import 'package:flutter_test/flutter_test.dart';
import 'package:tableturn_project0/Controller/BookingHelpers.dart';

void main() {
  group('BookingHelpers.getSlotsForDuration', () {
    test('returns consecutive slots for a valid start and duration', () {
      final slots = BookingHelpers.getSlotsForDuration('12:00', 3);

      expect(slots, ['12:00', '13:00', '14:00']);
    });

    test('returns remaining slots when duration runs past the end', () {
      final slots = BookingHelpers.getSlotsForDuration('21:00', 4);

      expect(slots, ['21:00', '22:00']);
    });

    test('returns an empty list for an unknown start slot', () {
      final slots = BookingHelpers.getSlotsForDuration('09:00', 2);

      expect(slots, isEmpty);
    });
  });
}
