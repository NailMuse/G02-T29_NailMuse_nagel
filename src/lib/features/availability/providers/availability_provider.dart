
import 'package:flutter/foundation.dart';

/// A period when the salon is closed, for example a holiday.
class ClosedPeriod {
  final DateTime start;
  final DateTime end;
  final String reason;

  const ClosedPeriod({
    required this.start,
    required this.end,
    required this.reason,
  });

  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }
}

class AvailabilityProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  String? _selectedTime;

  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;

  // Monday to Friday: evening slots.
  static const List<String> _weekdaySlots = [
    '7:00 pm',
    '8:00 pm',
    '9:00 pm',
  ];

  // Saturday and Sunday: 10:00 am to 7:00 pm (last slot starts at 6:00 pm).
  static const List<String> _weekendSlots = [
    '10:00 am',
    '11:00 am',
    '12:00 pm',
    '1:00 pm',
    '2:00 pm',
    '3:00 pm',
    '4:00 pm',
    '5:00 pm',
    '6:00 pm',
  ];

  /// The time slots for one date (weekday or weekend).
  static List<String> slotsFor(DateTime? date) {
    final isWeekend = date != null &&
        (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday);
    return isWeekend ? _weekendSlots : _weekdaySlots;
  }

  // Weekdays (1 = Monday ... 7 = Sunday) that the owner closed
  // on the Working Hours screen (UI-09).
  final Set<int> _closedWeekdays = {};

  bool isDayOpen(int weekday) => !_closedWeekdays.contains(weekday);

  // Closed periods set by the owner (for example a holiday).
  final List<ClosedPeriod> _closedPeriods = [];

  List<ClosedPeriod> get closedPeriods => List.unmodifiable(_closedPeriods);

  bool isDateOpen(DateTime date) =>
      isDayOpen(date.weekday) && !_closedPeriods.any((p) => p.contains(date));

  void addClosedPeriod(DateTime start, DateTime end, String reason) {
    _closedPeriods.add(
      ClosedPeriod(
        start: DateTime(start.year, start.month, start.day),
        end: DateTime(end.year, end.month, end.day),
        reason: reason.trim(),
      ),
    );
    _clearSelectionIfClosed();
    notifyListeners();
  }

  void removeClosedPeriod(int index) {
    if (index < 0 || index >= _closedPeriods.length) return;
    _closedPeriods.removeAt(index);
    notifyListeners();
  }

  // A chosen date that becomes closed cannot stay selected.
  void _clearSelectionIfClosed() {
    final date = _selectedDate;
    if (date != null && !isDateOpen(date)) {
      _selectedDate = null;
      _selectedTime = null;
    }
  }

  void setDayOpen(int weekday, bool open) {
    if (open) {
      _closedWeekdays.remove(weekday);
    } else {
      _closedWeekdays.add(weekday);
    }
    _clearSelectionIfClosed();
    notifyListeners();
  }

  /// The slots depend on the chosen date.
  List<String> get availableTimeSlots =>
      List.unmodifiable(slotsFor(_selectedDate));

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
    if (!availableTimeSlots.contains(time)) return;

    _selectedTime = time;
    notifyListeners();
  }

  void clearSelection() {
    _selectedDate = null;
    _selectedTime = null;
    notifyListeners();
  }
}
