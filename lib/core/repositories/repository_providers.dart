import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/members/data/repositories/user_repository.dart';
import '../../features/members/data/repositories/user_repository_impl.dart';
import '../../features/home/data/repositories/post_repository.dart';
import '../../features/home/data/repositories/post_repository_impl.dart';
import '../providers/firebase_provider.dart';

/// Re-export Firebase providers from centralized location
/// These are now nullable to handle Firebase not being initialized gracefully

/// User repository provider
/// Provides UserRepository implementation
/// Returns null if Firebase is not initialized
final userRepositoryProvider = Provider<UserRepository?>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final auth = ref.watch(firebaseAuthProvider);

  if (firestore == null || auth == null) {
    return null; // Firebase not initialized
  }

  return UserRepositoryImpl(firestore: firestore, auth: auth);
});

/// Post repository provider
/// Provides PostRepository implementation
/// Returns null if Firebase is not initialized
final postRepositoryProvider = Provider<PostRepository?>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);

  if (firestore == null) {
    return null; // Firebase not initialized
  }

  return PostRepositoryImpl(firestore: firestore);
});
