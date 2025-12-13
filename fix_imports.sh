#!/bin/bash
# Fix all import paths in the project

cd "$(dirname "$0")"

# Fix auth provider imports
echo "Fixing auth_provider imports..."

# From auth/presentation/screens to auth/providers = ../../providers
find lib/features/auth/presentation/screens -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*auth/providers/auth_provider\.dart['\"]|import '../../providers/auth_provider.dart';|g" {} \;

# From other features to auth/providers = ../../../../auth/providers
find lib/features/{admin,members,news,events,committee,home}/presentation/screens -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*auth/providers/auth_provider\.dart['\"]|import '../../../../auth/providers/auth_provider.dart';|g" {} \;

# Fix utils imports
echo "Fixing utils imports..."
find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*core/utils\.dart['\"]|import '../../../../core/utils/app_utils.dart';|g" {} \;

# Fix design_tokens imports
echo "Fixing design_tokens imports..."
find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*core/design_tokens\.dart['\"]|import '../../../../core/constants/design_tokens.dart';|g" {} \;

# Fix theme imports
echo "Fixing theme imports..."
find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*core/theme\.dart['\"]|import '../../../../core/theme/app_theme.dart';|g" {} \;

# Fix localization imports
echo "Fixing localization imports..."
find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*l10n/app_localizations\.dart['\"]|import '../../../../l10n/app_localizations.dart';|g" {} \;

# Fix shared imports
echo "Fixing shared imports..."
find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*shared/data/firebase_service\.dart['\"]|import '../../../../shared/data/firebase_service.dart';|g" {} \;

find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*shared/models/post_model\.dart['\"]|import '../../../../shared/models/post_model.dart';|g" {} \;

# Fix language_switcher imports
echo "Fixing language_switcher imports..."
find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*widgets/language_switcher\.dart['\"]|import '../../../../core/widgets/language_switcher.dart';|g" {} \;

# Fix locale_provider imports
echo "Fixing locale_provider imports..."
find lib/features -name "*.dart" -exec sed -i '' \
  "s|import ['\"].*providers/locale_provider\.dart['\"]|import '../../../../core/providers/locale_provider.dart';|g" {} \;

echo "All imports fixed!"

