// lib/utils/user_session.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSession {
  static User? get _user => Supabase.instance.client.auth.currentUser;

  static String get fullName {
    return _user?.userMetadata?['full_name'] ?? _user?.email ?? 'User';
  }

  static String get initials {
    final name = fullName.trim();
    final parts = name.split(' ');
    return parts.length == 1
        ? parts[0][0].toUpperCase()
        : (parts[0][0] + parts.last[0]).toUpperCase();
  }

  static bool get isGuest => _user == null;
}
