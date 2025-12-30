import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves a Firebase Storage object path (e.g. `committee_members/mukesh_07.png`)
/// into a public HTTPS download URL via `getDownloadURL()`.
///
/// Riverpod caches results per-path while the provider is alive, which avoids
/// re-fetching URLs while browsing the committee screen.
final committeeImageUrlProvider =
    FutureProvider.family<String?, String?>((ref, storagePath) async {
  if (storagePath == null || storagePath.trim().isEmpty) return null;

  try {
    return await FirebaseStorage.instance.ref(storagePath).getDownloadURL();
  } catch (_) {
    // Keep UI resilient: fall back to default avatar if URL cannot be fetched.
    return null;
  }
});


