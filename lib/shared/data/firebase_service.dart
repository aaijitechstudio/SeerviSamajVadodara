import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/members/domain/models/user_model.dart';
import '../models/post_model.dart';
import '../../core/utils/network_helper.dart';
import '../../core/utils/app_logger.dart';

class FirebaseService {
  // Lazy initialization to ensure Firebase is initialized first
  static FirebaseAuth get _auth {
    if (Firebase.apps.isEmpty) {
      throw Exception(
          'Firebase not initialized. Call Firebase.initializeApp() first.');
    }
    return FirebaseAuth.instance;
  }

  static FirebaseFirestore get _firestore {
    if (Firebase.apps.isEmpty) {
      throw Exception(
          'Firebase not initialized. Call Firebase.initializeApp() first.');
    }
    return FirebaseFirestore.instance;
  }

  static FirebaseStorage get _storage {
    if (Firebase.apps.isEmpty) {
      throw Exception(
          'Firebase not initialized. Call Firebase.initializeApp() first.');
    }
    return FirebaseStorage.instance;
  }

  // Auth methods
  static Future<UserCredential?> signUpWithEmail({
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
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      if (credential.user?.uid != null) {
        try {
          final userData = {
            'name': name,
            'email': email,
            'phone': phone,
            'createdAt': FieldValue.serverTimestamp(),
            'isVerified': false,
            'isActive': true,
            'role': 'member',
          };

          // Add optional fields
          if (profileImageUrl != null) {
            userData['profileImageUrl'] = profileImageUrl;
          }

          // Store additional info in additionalInfo map
          final additionalInfo = <String, dynamic>{};
          if (gotra != null && gotra.isNotEmpty) {
            additionalInfo['gotra'] = gotra;
          }
          if (vadodaraAddress != null && vadodaraAddress.isNotEmpty) {
            additionalInfo['vadodaraAddress'] = vadodaraAddress;
          }
          if (nativeAddress != null && nativeAddress.isNotEmpty) {
            additionalInfo['nativeAddress'] = nativeAddress;
          }
          if (pratisthanName != null && pratisthanName.isNotEmpty) {
            additionalInfo['pratisthanName'] = pratisthanName;
          }

          if (additionalInfo.isNotEmpty) {
            userData['additionalInfo'] = additionalInfo;
          }

          await _firestore
              .collection('users')
              .doc(credential.user!.uid)
              .set(userData);

          // Verify document was created
          final doc = await _firestore
              .collection('users')
              .doc(credential.user!.uid)
              .get();
          if (!doc.exists) {
            throw Exception('Failed to create user document in Firestore');
          }
        } on FirebaseException catch (e) {
          // Handle Firestore specific errors
          String errorMessage;
          switch (e.code) {
            case 'permission-denied':
              errorMessage =
                  'Permission denied. Please check Firestore security rules.';
              break;
            case 'unavailable':
              errorMessage =
                  'Firestore is temporarily unavailable. Please try again.';
              break;
            default:
              errorMessage =
                  'Failed to create user profile: ${e.message ?? e.code}';
          }
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Failed to create user document: ${e.toString()}');
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'This email is already registered. Please sign in instead.';
          break;
        case 'weak-password':
          errorMessage =
              'Password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address. Please check and try again.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Email/password sign-up is not enabled. Please contact support.';
          break;
        default:
          errorMessage = 'Sign up failed: ${e.message ?? e.code}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  static Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage =
              'No account found with this email. Please sign up first.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address. Please check and try again.';
          break;
        case 'user-disabled':
          errorMessage =
              'This account has been disabled. Please contact support.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Sign in failed: ${e.message ?? e.code}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    // Also sign out from Google Sign In if used
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
  }

  // Delete user account
  static Future<void> deleteUserAccount(String uid) async {
    try {
      // Delete user document from Firestore
      await _firestore.collection('users').doc(uid).delete();

      // Delete user's posts
      final userPostsSnapshot = await _firestore
          .collection('posts')
          .where('authorId', isEqualTo: uid)
          .get();

      final batch = _firestore.batch();
      for (final doc in userPostsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Delete user's comments (comments are in posts/{postId}/comments subcollection)
      // Get all posts first, then delete comments from each post
      final allPostsSnapshot = await _firestore
          .collection('posts')
          .get();

      final commentsBatch = _firestore.batch();
      int batchCount = 0;

      for (final postDoc in allPostsSnapshot.docs) {
        final commentsSnapshot = await postDoc.reference
            .collection('comments')
            .where('authorId', isEqualTo: uid)
            .get();

        for (final commentDoc in commentsSnapshot.docs) {
          commentsBatch.delete(commentDoc.reference);
          batchCount++;

          // Firestore batch limit is 500 operations
          if (batchCount >= 450) {
            await commentsBatch.commit();
            batchCount = 0;
          }
        }
      }

      if (batchCount > 0) {
        await commentsBatch.commit();
      }

      // Delete Firebase Auth user
      final user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
      }

      // Sign out
      await signOut();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      // For iOS, GoogleSignIn automatically reads CLIENT_ID from GoogleService-Info.plist
      // serverClientId is optional and only needed for server-side token verification
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Validate that we have the required tokens
      if (googleAuth.idToken == null) {
        throw Exception(
            'Google Sign In failed: ID token is missing. Please try again.');
      }

      if (googleAuth.accessToken == null) {
        throw Exception(
            'Google Sign In failed: Access token is missing. Please try again.');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore, if not create
      if (userCredential.user != null) {
        final userData = await getUserData(userCredential.user!.uid);
        if (userData == null) {
          // Create user document in Firestore
          final user = userCredential.user!;
          await createUserFromGoogle(
            uid: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? 'User',
            photoUrl: user.photoURL,
          );
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'An account already exists with a different sign-in method.';
          break;
        case 'invalid-credential':
        case 'invalid-argument':
          errorMessage =
              'Invalid Google Sign In credentials. Please try again or check your Google account settings.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google Sign In is not enabled. Please contact support.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        default:
          errorMessage = 'Sign in failed: ${e.message ?? e.code}';
      }
      AppLogger.error('Google Sign In FirebaseAuthException', e);
      throw Exception(errorMessage);
    } catch (e) {
      AppLogger.error('Google Sign In error', e);
      // Provide more helpful error messages
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('malformed') ||
          errorString.contains('expired') ||
          errorString.contains('invalid')) {
        throw Exception(
            'Sign in failed: The authentication credentials are invalid. Please try signing in again.');
      }
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  // Create user from Google Sign In
  static Future<void> createUserFromGoogle({
    required String uid,
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    try {
      final userData = {
        'name': name,
        'email': email,
        'phone': '', // Will be filled later
        'role': 'member',
        'isVerified': false,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': photoUrl,
        'blockedUsers': [],
        'allowDirectMessages': true,
      };

      await _firestore.collection('users').doc(uid).set(userData);
    } catch (e) {
      throw Exception('Failed to create user from Google: $e');
    }
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // User methods
  static Future<UserModel?> getUserData(String uid) async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Ensures the user document exists in Firestore for the given Firebase user.
  ///
  /// This is critical for login methods that authenticate successfully but may
  /// not have created the corresponding `users/{uid}` document yet (e.g. older
  /// email/password accounts).
  static Future<void> ensureUserDocumentExistsFromFirebaseUser(
    User firebaseUser,
  ) async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      final docRef = _firestore.collection('users').doc(firebaseUser.uid);
      final doc = await docRef.get();
      if (doc.exists) return;

      final email = firebaseUser.email ?? '';
      final inferredName = (email.contains('@') ? email.split('@').first : '')
          .trim();
      final name = (firebaseUser.displayName ?? inferredName).trim().isNotEmpty
          ? (firebaseUser.displayName ?? inferredName).trim()
          : 'User';

      await docRef.set(
        {
          'name': name,
          'email': email,
          'phone': firebaseUser.phoneNumber ?? '',
          'role': 'member',
          'isVerified': firebaseUser.emailVerified,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'profileImageUrl': firebaseUser.photoURL,
          'blockedUsers': [],
          'allowDirectMessages': true,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to ensure user profile: $e');
    }
  }

  static Future<void> updateUserData(
      String uid, Map<String, dynamic> data) async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  static Future<List<UserModel>> getAllMembers() async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all members: $e');
    }
  }

  static Future<List<UserModel>> getMembersPaginated({
    String? lastDocumentId,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('users').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get members: $e');
    }
  }

  static Future<void> createUserFromPhone({
    required String uid,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': 'User', // Default name, can be updated later
        'email': '',
        'phone': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'isVerified': false,
        'isActive': true,
      });
    } catch (e) {
      throw Exception('Failed to create user from phone: $e');
    }
  }

  // Post methods
  static Future<void> createPost(PostModel post) async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      await _firestore.collection('posts').add(post.toMap());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  static Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  static Future<List<PostModel>> getPostsPaginated({
    String? lastDocumentId,
    int limit = 20,
  }) async {
    // Check network connectivity before making request
    await NetworkHelper.ensureNetworkConnectivity();

    try {
      Query query = _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('posts').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  static Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  static Future<void> updatePostLikes(
      String postId, List<String> likedBy, int likesCount) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likedBy': likedBy,
        'likesCount': likesCount,
      });
    } catch (e) {
      throw Exception('Failed to update post likes: $e');
    }
  }

  // Storage methods
  static Future<String> uploadImage(String path, List<int> imageBytes) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putData(Uint8List.fromList(imageBytes));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<String> uploadVideo(String path, List<int> videoBytes) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putData(Uint8List.fromList(videoBytes));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }
}
