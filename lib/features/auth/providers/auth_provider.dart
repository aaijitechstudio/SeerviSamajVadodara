import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../members/domain/models/user_model.dart';
import '../../../shared/data/firebase_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/providers/firebase_provider.dart';

// Re-export Firebase Auth provider from centralized location
// This provider now returns nullable FirebaseAuth to handle uninitialized state gracefully

// Current user stream provider
// Lazy initialization - only starts when accessed after Firebase is initialized
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);

  if (auth == null) {
    // If Firebase not initialized, return empty stream
    // This will be retried once Firebase is ready
    return Stream<User?>.value(null);
  }

  try {
    return auth.authStateChanges();
  } catch (e) {
    // If error occurs, return empty stream
    return Stream<User?>.value(null);
  }
});

// Current user model provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) async {
      if (user != null) {
        return await FirebaseService.getUserData(user.uid);
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth controller provider
final authControllerProvider = NotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});

// Auth state class
class AuthState {
  final bool isLoading;
  final bool isGoogleSignInLoading;
  final String? error;
  final UserModel? user;

  const AuthState({
    this.isLoading = false,
    this.isGoogleSignInLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isGoogleSignInLoading,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isGoogleSignInLoading:
          isGoogleSignInLoading ?? this.isGoogleSignInLoading,
      error: error,
      user: user ?? this.user,
    );
  }

  bool get isAuthenticated => user != null;
}

// Auth controller
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Initialize from Firebase Auth state
    _initializeFromFirebase();
    // Listen to auth state changes
    ref.listen<AsyncValue<User?>>(
      authStateProvider,
      (previous, next) {
        next.whenData((user) {
          if (user != null) {
            // User is authenticated via Firebase - fetch user data
            FirebaseService.getUserData(user.uid).then((userData) {
              state = state.copyWith(
                user: userData,
              );
            });
          } else {
            // User is not authenticated
            state = const AuthState();
          }
        });
      },
    );
    return const AuthState();
  }

  // Initialize from Firebase Auth
  Future<void> _initializeFromFirebase() async {
    try {
      final auth = ref.read(firebaseAuthProvider);

      if (auth == null) {
        return; // Firebase not ready yet
      }

      final currentUser = auth.currentUser;
      if (currentUser != null) {
        final userData = await FirebaseService.getUserData(currentUser.uid);
        state = state.copyWith(
          user: userData,
        );
      }
    } catch (e) {
      // Silently fail initialization - Firebase might not be ready
      AppLogger.debug('Auth initialization deferred: ${e.toString()}');
    }
  }

  // Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? gotra,
    String? vadodaraAddress,
    String? nativeAddress,
    String? pratisthanName,
    String? profileImageUrl,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    // Check if Firebase is initialized before attempting sign up
    final auth = ref.read(firebaseAuthProvider);
    if (auth == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Firebase is not initialized. Please restart the app or check your internet connection.',
      );
      return false;
    }

    try {
      final credential = await FirebaseService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        gotra: gotra,
        vadodaraAddress: vadodaraAddress,
        nativeAddress: nativeAddress,
        pratisthanName: pratisthanName,
        profileImageUrl: profileImageUrl,
      );

      if (credential?.user != null) {
        final userData =
            await FirebaseService.getUserData(credential!.user!.uid);
        state = state.copyWith(
          isLoading: false,
          user: userData,
        );
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      // Extract user-friendly error message
      String errorMessage = e.toString();

      // Check for Firebase initialization errors
      if (errorMessage.contains('Firebase not initialized') ||
          errorMessage.contains('not been correctly initialized')) {
        errorMessage = 'Firebase is not initialized. Please restart the app or check your internet connection.';
      } else if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return false;
    }
  }

  // Sign in with email and password
  Future<bool> signIn({
required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    // Check if Firebase is initialized before attempting sign in
    final auth = ref.read(firebaseAuthProvider);
    if (auth == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Firebase is not initialized. Please restart the app or check your internet connection.',
      );
      return false;
    }

    try {
      final credential = await FirebaseService.signInWithEmail(
        email: email,
        password: password,
      );

      if (credential?.user != null) {
        // Fetch user data and ensure it's loaded
        final userData =
            await FirebaseService.getUserData(credential!.user!.uid);

        if (userData == null) {
          // User authenticated but no Firestore document - create one
          AppLogger.warning(
              'User authenticated but no Firestore document found. Creating...');
          // This should not happen in normal flow, but handle gracefully
          state = state.copyWith(
            isLoading: false,
            error: 'User account not properly set up. Please contact support.',
          );
          return false;
        }

        // Update state with user data
        state = state.copyWith(
          isLoading: false,
          user: userData,
          error: null,
        );

        // Force refresh auth state listener
        ref.invalidate(authStateProvider);

        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      // Extract user-friendly error message
      String errorMessage = e.toString();

      // Check for Firebase initialization errors
      if (errorMessage.contains('Firebase not initialized') ||
          errorMessage.contains('not been correctly initialized')) {
        errorMessage = 'Firebase is not initialized. Please restart the app or check your internet connection.';
      } else if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return false;
    }
  }

  // Sign in with phone number (OTP)
  Future<void> signInWithPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final auth = ref.read(firebaseAuthProvider);

      if (auth == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Firebase is not initialized. Please restart the app.',
        );
        return;
      }

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Verify OTP
  Future<bool> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final auth = ref.read(firebaseAuthProvider);

      if (auth == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Firebase is not initialized. Please restart the app.',
        );
        return false;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if user exists in Firestore
        var userData =
            await FirebaseService.getUserData(userCredential.user!.uid);

        // If user doesn't exist, create a new user document
        if (userData == null) {
          await FirebaseService.createUserFromPhone(
            uid: userCredential.user!.uid,
            phoneNumber: userCredential.user!.phoneNumber ?? '',
          );
          userData =
              await FirebaseService.getUserData(userCredential.user!.uid);
        }

        state = state.copyWith(
          isLoading: false,
          user: userData,
        );
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await FirebaseService.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImageUrl,
  }) async {
    if (state.user == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      await FirebaseService.updateUserData(state.user!.id, updateData);

      final updatedUser = await FirebaseService.getUserData(state.user!.id);
      state = state.copyWith(
        isLoading: false,
        user: updatedUser,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final auth = ref.read(firebaseAuthProvider);

      if (auth == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Firebase is not initialized. Please restart the app.',
        );
        return false;
      }

      await auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      // Extract user-friendly error message
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      isGoogleSignInLoading: true,
      error: null,
    );

    // Check if Firebase is initialized before attempting sign in
    final auth = ref.read(firebaseAuthProvider);
    if (auth == null) {
      state = state.copyWith(
        isLoading: false,
        isGoogleSignInLoading: false,
        error: 'Firebase is not initialized. Please restart the app or check your internet connection.',
      );
      return false;
    }

    try {
      final credential = await FirebaseService.signInWithGoogle();

      if (credential?.user != null) {
        // Fetch user data and ensure it's loaded
        final userData =
            await FirebaseService.getUserData(credential!.user!.uid);

        if (userData == null) {
          state = state.copyWith(
            isLoading: false,
            isGoogleSignInLoading: false,
            error: 'User account not properly set up. Please contact support.',
          );
          return false;
        }

        // Update state with user data
        state = state.copyWith(
          isLoading: false,
          isGoogleSignInLoading: false,
          user: userData,
          error: null,
        );

        // Force refresh auth state listener
        ref.invalidate(authStateProvider);

        return true;
      }
      state = state.copyWith(
        isLoading: false,
        isGoogleSignInLoading: false,
      );
      return false;
    } catch (e) {
      // Extract user-friendly error message
      String errorMessage = e.toString();

      // Check for Firebase initialization errors
      if (errorMessage.contains('Firebase not initialized') ||
          errorMessage.contains('not been correctly initialized')) {
        errorMessage = 'Firebase is not initialized. Please restart the app or check your internet connection.';
      } else if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      state = state.copyWith(
        isLoading: false,
        isGoogleSignInLoading: false,
        error: errorMessage,
      );
      return false;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    if (state.user == null) return;

    try {
      final userData = await FirebaseService.getUserData(state.user!.id);
      if (userData != null) {
        state = state.copyWith(user: userData);
      }
    } catch (e) {
      // Silently fail - user data refresh is not critical
      AppLogger.debug('Failed to refresh user data: $e');
    }
  }
}
