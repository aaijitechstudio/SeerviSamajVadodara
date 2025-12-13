/// Script to create test accounts in Firebase
///
/// Run with: dart run scripts/create_test_accounts.dart
///
/// Note: This requires Firebase to be initialized and the app to be running
/// For direct creation, use Firebase Console or Firebase CLI

import 'dart:io';

void main() async {
  print('🚀 Creating Test Accounts for Seervi Kshatriya Samaj Vadodara\n');

  print(
      '⚠️  Note: Firebase Auth users cannot be created directly from Dart scripts');
  print('   due to security restrictions. Use one of these methods:\n');

  print('📋 Method 1: Use Firebase Console (Easiest)');
  print(
      '   1. Go to: https://console.firebase.google.com/project/seervikshatriyasamajvadodara/authentication/users');
  print('   2. Click "Add user"');
  print('   3. Enter email and password');
  print('   4. Click "Add user"\n');

  print('📋 Method 2: Use Firebase CLI');
  print('   Install: npm install -g firebase-tools');
  print('   Login: firebase login');
  print('   Create user: firebase auth:import users.json\n');

  print('📋 Method 3: Use App Sign-Up (Recommended)');
  print('   1. Run your Flutter app: flutter run');
  print('   2. Use Sign Up screen to create accounts');
  print('   3. Then update role in Firestore Console\n');

  print('📋 Method 4: Use Firebase Admin SDK (Node.js)');
  print('   See: scripts/create_test_accounts_node.js\n');

  print('✅ Test Account Details:');
  print('\n   Account 1 (Regular User):');
  print('   Email: officialjagdish@gmail.com');
  print('   Password: 12345678');
  print('   Name: Jagdish Kumar');
  print('   Phone: 8947038661');
  print('   Role: member');

  print('\n   Account 2 (Admin User):');
  print('   Email: aaijitechstudio@gmail.com');
  print('   Password: 12345678');
  print('   Name: Aaiji Tech');
  print('   Phone: 8947038662');
  print('   Role: admin\n');

  print('📝 After creating accounts:');
  print('   1. Go to Firestore Console');
  print('   2. Find user documents in "users" collection');
  print('   3. Update "role" field to "admin" for admin account\n');

  exit(0);
}
