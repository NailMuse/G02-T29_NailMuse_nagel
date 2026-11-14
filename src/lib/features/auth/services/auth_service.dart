// src/lib/features/auth/services/auth_service.dart
// NFR-02 Login / Register (UI-01). Written by Aida.
//
// DEMO VERSION: accounts live in memory (like MockData) so the team can test
// the app now. Later this file can be changed to use Firebase Auth. The
// screens only call login() and register(), so they will not need to change.
//
// The owner account is made here once. Register is for customers only,
// so nobody can sign up as the owner.

class AuthRoles {
  AuthRoles._();

  static const String customer = 'customer';
  static const String owner = 'owner';
}

class AuthUser {
  final String name;
  final String email;
  final String phone;
  final String role; // AuthRoles.customer | AuthRoles.owner

  const AuthUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  bool get isOwner => role == AuthRoles.owner;
}

class _Account {
  final AuthUser user;
  final String password;

  const _Account(this.user, this.password);
}

class AuthService {
  AuthService._();

  // Demo accounts only. Never put real passwords in code.
  static final List<_Account> _accounts = [
    const _Account(
      AuthUser(
        name: 'Michelle',
        email: 'owner@nagel.com',
        phone: '0123456789',
        role: AuthRoles.owner,
      ),
      'owner123',
    ),
    const _Account(
      AuthUser(
        name: 'Demo Customer',
        email: 'customer@nagel.com',
        phone: '0129876543',
        role: AuthRoles.customer,
      ),
      'customer123',
    ),
  ];

  /// The person who is logged in now (null when nobody is).
  static AuthUser? currentUser;

  /// Returns the user when email and password match, otherwise null.
  static AuthUser? login(String email, String password) {
    final cleanEmail = email.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.user.email == cleanEmail && account.password == password) {
        currentUser = account.user;
        return account.user;
      }
    }
    return null;
  }

  /// Makes a new CUSTOMER account. Returns an error message,
  /// or null when it worked.
  static String? register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final exists = _accounts.any((a) => a.user.email == cleanEmail);
    if (exists) {
      return 'This email is already registered';
    }
    final user = AuthUser(
      name: name.trim(),
      email: cleanEmail,
      phone: phone.trim(),
      role: AuthRoles.customer,
    );
    _accounts.add(_Account(user, password));
    currentUser = user;
    return null;
  }

  static void logout() {
    currentUser = null;
  }
}
