import 'package:flutter/foundation.dart';

class DesignPreferencesProvider extends ChangeNotifier {
  String? _selectedStyle;
  String? _selectedColour;
  String? _selectedShape;

  String _otherColour = '';
  String _designNotes = '';
  String _referenceImageUrl = '';

  String? get selectedStyle => _selectedStyle;
  String? get selectedColour => _selectedColour;
  String? get selectedShape => _selectedShape;

  String get otherColour => _otherColour;

  /// The colour text to save with the booking.
  /// When the customer picked "Other", this is the colour they typed.
  String? get colourForBooking {
    if (_selectedColour == 'Other' && _otherColour.trim().isNotEmpty) {
      return 'Other: ${_otherColour.trim()}';
    }
    return _selectedColour;
  }

  String get designNotes => _designNotes;
  String get referenceImageUrl => _referenceImageUrl;

  final List<String> styles = [
    'Plain',
    'French',
    'Glitter',
  ];

  final List<String> colours = [
    'Nude',
    'Pink',
    'Red',
    'White',
    'Black',
    'Blue',
    'Purple',
    'Other',
  ];

  final List<String> shapes = [
    'Almond',
    'Square',
    'Round',
  ];

  void selectStyle(String style) {
    _selectedStyle = style;
    notifyListeners();
  }

  void selectColour(String colour) {
    _selectedColour = colour;
    notifyListeners();
  }

  void updateOtherColour(String colour) {
    _otherColour = colour;
    notifyListeners();
  }

  void selectShape(String shape) {
    _selectedShape = shape;
    notifyListeners();
  }

  void updateNotes(String notes) {
    _designNotes = notes;
    notifyListeners();
  }

  void updateReferenceImageUrl(String url) {
    _referenceImageUrl = url;
    notifyListeners();
  }

  void clearPreferences() {
    _selectedStyle = null;
    _selectedColour = null;
    _selectedShape = null;

    _otherColour = '';
    _designNotes = '';
    _referenceImageUrl = '';

    notifyListeners();
  }
}