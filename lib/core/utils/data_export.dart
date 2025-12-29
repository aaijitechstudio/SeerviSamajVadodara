import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import '../../features/members/domain/models/user_model.dart';
import '../utils/auth_preferences.dart';

/// Data export utility for GDPR compliance
/// Allows users to export their personal data
class DataExport {
  /// Export user data to JSON format
  static Future<String> exportUserData(UserModel user) async {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'userData': {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'profileImageUrl': user.profileImageUrl,
        'samajId': user.samajId,
        'area': user.area,
        'profession': user.profession,
        'address': user.address,
        'role': user.role.toString(),
        'isVerified': user.isVerified,
        'isActive': user.isActive,
        'createdAt': user.createdAt.toIso8601String(),
        'familyMembers': user.familyMembers,
        'blockedUsers': user.blockedUsers,
        'allowDirectMessages': user.allowDirectMessages,
        'additionalInfo': user.additionalInfo,
      },
      'loginHistory': await AuthPreferences.getLoginHistory(),
      'preferences': {
        'rememberMe': await AuthPreferences.getRememberMe(),
        'savedEmail': await AuthPreferences.getSavedEmail(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Export user data and share as text
  static Future<void> exportAndShare(UserModel user) async {
    try {
      // Generate JSON data
      final jsonData = await exportUserData(user);

      // Share as text
      await Share.share(
        jsonData,
        subject: 'My Data Export (JSON) - Seervi Kshatriya Samaj Vadodara',
      );
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  /// Export user data as text (for display)
  static Future<String> exportAsText(UserModel user) async {
    final buffer = StringBuffer();
    buffer.writeln('=' * 50);
    buffer.writeln('SEERVI KSHATRIYA SAMAJ VADODARA');
    buffer.writeln('Personal Data Export');
    buffer.writeln('=' * 50);
    buffer.writeln();
    buffer.writeln('Export Date: ${DateTime.now().toString()}');
    buffer.writeln();
    buffer.writeln('-' * 50);
    buffer.writeln('USER INFORMATION');
    buffer.writeln('-' * 50);
    buffer.writeln('ID: ${user.id}');
    buffer.writeln('Name: ${user.name}');
    buffer.writeln('Email: ${user.email}');
    buffer.writeln('Phone: ${user.phone}');
    buffer.writeln('Samaj ID: ${user.samajId ?? 'N/A'}');
    buffer.writeln('Area: ${user.area ?? 'N/A'}');
    buffer.writeln('Profession: ${user.profession ?? 'N/A'}');
    buffer.writeln('Address: ${user.address ?? 'N/A'}');
    buffer.writeln('Role: ${user.role}');
    buffer.writeln('Verified: ${user.isVerified ? 'Yes' : 'No'}');
    buffer.writeln('Active: ${user.isActive ? 'Yes' : 'No'}');
    buffer.writeln('Created At: ${user.createdAt.toString()}');

    if (user.familyMembers != null && user.familyMembers!.isNotEmpty) {
      buffer.writeln('Family Members: ${user.familyMembers!.join(', ')}');
    }

    if (user.additionalInfo != null && user.additionalInfo!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Additional Information:');
      user.additionalInfo!.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }

    // Login History
    final loginHistory = await AuthPreferences.getLoginHistory();
    if (loginHistory.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('-' * 50);
      buffer.writeln('LOGIN HISTORY');
      buffer.writeln('-' * 50);
      for (var i = 0; i < loginHistory.length; i++) {
        final activity = loginHistory[i];
        buffer.writeln('${i + 1}. ${activity['method'] ?? 'Unknown'}');
        buffer.writeln('   Email: ${activity['email'] ?? 'N/A'}');
        buffer.writeln('   Date: ${activity['timestamp'] ?? 'N/A'}');
        if (activity['deviceInfo'] != null) {
          buffer.writeln('   Device: ${activity['deviceInfo']}');
        }
        buffer.writeln();
      }
    }

    // Preferences
    buffer.writeln('-' * 50);
    buffer.writeln('PREFERENCES');
    buffer.writeln('-' * 50);
    final rememberMe = await AuthPreferences.getRememberMe();
    buffer.writeln('Remember Me: ${rememberMe ? 'Yes' : 'No'}');
    final savedEmail = await AuthPreferences.getSavedEmail();
    if (savedEmail != null) {
      buffer.writeln('Saved Email: $savedEmail');
    }

    buffer.writeln();
    buffer.writeln('=' * 50);
    buffer.writeln('End of Export');
    buffer.writeln('=' * 50);

    return buffer.toString();
  }

  /// Export and share as text
  static Future<void> exportAndShareAsText(UserModel user) async {
    try {
      // Generate text data
      final textData = await exportAsText(user);

      // Share as text
      await Share.share(
        textData,
        subject: 'My Data Export - Seervi Kshatriya Samaj Vadodara',
      );
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }
}
