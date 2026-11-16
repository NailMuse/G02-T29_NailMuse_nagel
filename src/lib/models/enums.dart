// src/lib/models/enums.dart
// Enum & String Literal Standardization (team rule).
// Use these constants everywhere (models, Firestore queries, screens) so the
// strings are always spelled the same way.

class AppointmentStatus {
  static const pending = 'pending';
  static const confirmed = 'confirmed';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
  static const List<String> values = [pending, confirmed, completed, cancelled];
}

class UserRole {
  static const customer = 'customer';
  static const owner = 'owner';
  static const List<String> values = [customer, owner];
}

class ServiceCategory {
  static const gel = 'gel';
  static const extensions = 'extensions';
  static const care = 'care';
  static const List<String> values = [gel, extensions, care];
}

class InventoryCategory {
  static const polish = 'polish';
  static const tips = 'tips';
  static const charms = 'charms';
  static const tools = 'tools';
  static const List<String> values = [polish, tips, charms, tools];
}

/// Deposit status values (deposits collection, FR-11).
/// 'forfeited' = deposit burned (for example a late cancellation, less than 48 hours).
class DepositStatus {
  static const pending = 'pending';
  static const verified = 'verified';
  static const forfeited = 'forfeited';
  static const List<String> values = [pending, verified, forfeited];
}
