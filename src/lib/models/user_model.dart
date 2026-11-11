// src/lib/models/user_model.dart
// Firestore collection: users   |   Primary key: userId (Firebase Auth UID)
// Requirement: NFR-02 (security / roles). Role values: see enums.dart (UserRole).

import 'enums.dart';
import 'model_utils.dart';

class UserModel {
  final String userId; // Firebase Auth UID
  final String userName; // full name of customer or owner
  final String userEmail; // account email address
  final String userPhone; // contact number
  final String userRole; // 'customer' | 'owner'
  final DateTime userCreatedAt; // account creation timestamp

  const UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userRole,
    required this.userCreatedAt,
  });

  bool get isOwner => userRole == UserRole.owner;

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userPhone: data['userPhone'] ?? '',
      userRole: data['userRole'] ?? UserRole.customer,
      userCreatedAt: toDateTime(data['userCreatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userRole': userRole,
      'userCreatedAt': userCreatedAt,
    };
  }
}
