// src/lib/models/model_utils.dart
// Small helper so the models work with mock data (DateTime) AND with Firestore (Timestamp)
// without importing cloud_firestore into the models.

/// Accepts DateTime, ISO-8601 String, or a Firestore Timestamp (anything with toDate()).
DateTime? toDateTimeOrNull(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  try {
    return (value as dynamic).toDate() as DateTime;
  } catch (_) {
    return null;
  }
}

/// Same as above but never returns null (uses [fallback], or the year 1970).
DateTime toDateTime(dynamic value, {DateTime? fallback}) =>
    toDateTimeOrNull(value) ??
    fallback ??
    DateTime.fromMillisecondsSinceEpoch(0);
