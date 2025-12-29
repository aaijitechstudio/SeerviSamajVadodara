import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI State Provider for simple UI state management
/// Use StateProvider.autoDispose for screen-specific state

/// Search state provider (auto-disposing)
/// Use this for search toggle state in screens
final searchActiveProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Visibility toggle provider (auto-disposing)
/// Use this for visibility toggles
final visibilityToggleProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Members search active provider (auto-disposing)
/// Use this for members search toggle state
final membersSearchActiveProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Committee search active provider (auto-disposing)
/// Use this for committee search toggle state
final committeeSearchActiveProvider = StateProvider.autoDispose<bool>((ref) => false);

