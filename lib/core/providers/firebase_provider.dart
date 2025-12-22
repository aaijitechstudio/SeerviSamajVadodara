import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase initialization state provider
/// Tracks whether Firebase is initialized and ready to use
final firebaseInitializedProvider = Provider<bool>((ref) {
  return Firebase.apps.isNotEmpty;
});

/// Firebase Auth provider
/// Returns FirebaseAuth instance if Firebase is initialized, otherwise throws
/// Use this provider to safely access Firebase Auth
final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  if (!ref.watch(firebaseInitializedProvider)) {
    return null; // Return null instead of throwing to allow graceful handling
  }
  try {
    // Double-check that Firebase is actually ready
    if (Firebase.apps.isEmpty) {
      return null;
    }
    // Try to get the default app first to ensure it's ready
    // This will throw if Firebase isn't properly initialized
    Firebase.app();
    return FirebaseAuth.instance;
  } catch (e) {
    return null;
  }
});

/// Firebase Firestore provider
/// Returns Firestore instance if Firebase is initialized, otherwise throws
/// Use this provider to safely access Firestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore?>((ref) {
  if (!ref.watch(firebaseInitializedProvider)) {
    return null; // Return null instead of throwing to allow graceful handling
  }
  try {
    // Double-check that Firebase is actually ready
    if (Firebase.apps.isEmpty) {
      return null;
    }
    // Try to get the default app first to ensure it's ready
    // This will throw if Firebase isn't properly initialized
    Firebase.app();
    return FirebaseFirestore.instance;
  } catch (e) {
    return null;
  }
});

/// Helper provider to check if Firebase services are available
final firebaseAvailableProvider = Provider<bool>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  return auth != null && firestore != null;
});
