// Script to create test accounts in Firebase
//
// Run with: dart run scripts/create_test_accounts.dart
//
// Note: Firebase Auth users cannot be created directly from a Dart script in most cases.
// For direct creation, use Firebase Console / CLI or an Admin SDK.

import 'dart:io';

void main() async {
  stdout.writeln('Creating Test Accounts for Seervi Kshatriya Samaj Vadodara\n');

  stdout.writeln(
      'Note: Firebase Auth users cannot be created directly from Dart scripts');
  stdout.writeln('due to security restrictions. Use one of these methods:\n');

  stdout.writeln('Method 1: Use Firebase Console (Easiest)');
  stdout.writeln(
      '   1. Go to: https://console.firebase.google.com/project/seervikshatriyasamajvadodara/authentication/users');
  stdout.writeln('   2. Click "Add user"');
  stdout.writeln('   3. Enter email and password');
  stdout.writeln('   4. Click "Add user"\n');

  stdout.writeln('Method 2: Use Firebase CLI');
  stdout.writeln('   Install: npm install -g firebase-tools');
  stdout.writeln('   Login: firebase login');
  stdout.writeln('   Create user: firebase auth:import users.json\n');

  stdout.writeln('Method 3: Use App Sign-Up (Recommended)');
  stdout.writeln('   1. Run your Flutter app: flutter run');
  stdout.writeln('   2. Use Sign Up screen to create accounts');
  stdout.writeln('   3. Then update role in Firestore Console\n');

  stdout.writeln('Method 4: Use Firebase Admin SDK (Node.js)');
  stdout.writeln('   See: scripts/create_test_accounts_node.js\n');

  stdout.writeln('Test Account Details:');
  stdout.writeln('\n   Account 1 (Regular User):');
  stdout.writeln('   Email: officialjagdish@gmail.com');
  stdout.writeln('   Password: 12345678');
  stdout.writeln('   Name: Jagdish Kumar');
  stdout.writeln('   Phone: 8947038661');
  stdout.writeln('   Role: member');

  stdout.writeln('\n   Account 2 (Admin User):');
  stdout.writeln('   Email: aaijitechstudio@gmail.com');
  stdout.writeln('   Password: 12345678');
  stdout.writeln('   Name: Aaiji Tech');
  stdout.writeln('   Phone: 8947038662');
  stdout.writeln('   Role: admin\n');

  stdout.writeln('After creating accounts:');
  stdout.writeln('   1. Go to Firestore Console');
  stdout.writeln('   2. Find user documents in "users" collection');
  stdout.writeln('   3. Update "role" field to "admin" for admin account\n');

  exit(0);
}
