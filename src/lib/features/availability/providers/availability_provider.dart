
import 'package:flutter/foundation.dart';

class AvailabilityProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  String? _selectedTime;

  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;

  final List<String> _availableTimeSlots = [
    '7:00 pm',
    '8:00 pm',
    '9:00 pm',
  ];

  List<String> get availableTimeSlots =>
      List.unmodifiable(_availableTimeSlots);

  bool get hasCompleteSelection =>
      _selectedDate != null && _selectedTime != null;

  void selectDate(DateTime date) {
    _selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    // Reset time when the date changes.
    _selectedTime = null;

    notifyListeners();
  }

  void selectTime(String time) {
    if (!_availableTimeSlots.contains(time)) return;

    _selectedTime = time;
    notifyListeners();
  }

  void clearSelection() {
    _selectedDate = null;
    _selectedTime = null;
    notifyListeners();
  }
}
