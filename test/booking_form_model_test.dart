import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tableturn_project0/Model/bookingFormModel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookingFormModel persistence', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saves and loads booking selections', () async {
      final model = BookingFormModel()
        ..selectedDate = DateTime(2026, 4, 27)
        ..selectedTable = 'table3'
        ..selectedSlot = '14:00'
        ..duration = 2
        ..guests = 4
        ..selectedBoardgame = 'catan'
        ..specialRequests = 'Window seat';

      await model.save();

      final restored = BookingFormModel();
      await restored.load();

      expect(restored.selectedDate, DateTime(2026, 4, 27));
      expect(restored.selectedTable, 'table3');
      expect(restored.selectedSlot, '14:00');
      expect(restored.duration, 2);
      expect(restored.guests, 4);
      expect(restored.selectedBoardgame, 'catan');
      expect(restored.specialRequests, 'Window seat');
    });

    test('clear resets in-memory state and stored preferences', () async {
      final model = BookingFormModel()
        ..selectedDate = DateTime(2026, 4, 27)
        ..selectedTable = 'table1'
        ..selectedSlot = '10:00'
        ..duration = 3
        ..guests = 5
        ..selectedBoardgame = 'azul'
        ..specialRequests = 'Birthday group';

      await model.save();
      await model.clear();

      expect(model.selectedDate, isNull);
      expect(model.selectedTable, isNull);
      expect(model.selectedSlot, isNull);
      expect(model.duration, 1);
      expect(model.guests, 1);
      expect(model.selectedBoardgame, isNull);
      expect(model.specialRequests, isEmpty);

      final restored = BookingFormModel();
      await restored.load();

      expect(restored.selectedDate, isNull);
      expect(restored.selectedTable, isNull);
      expect(restored.selectedSlot, isNull);
      expect(restored.duration, 1);
      expect(restored.guests, 1);
      expect(restored.selectedBoardgame, isNull);
      expect(restored.specialRequests, isEmpty);
    });
  });
}
