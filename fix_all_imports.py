#!/usr/bin/env python3
"""Fix all import paths in the Flutter project"""
import os
import re
from pathlib import Path

# Target files and their correct locations
TARGETS = {
    'auth_provider.dart': 'lib/features/auth/providers/auth_provider.dart',
    'user_model.dart': 'lib/features/members/domain/models/user_model.dart',
    'announcement_model.dart': 'lib/features/news/domain/models/announcement_model.dart',
    'event_model.dart': 'lib/features/events/domain/models/event_model.dart',
    'committee_model.dart': 'lib/features/committee/domain/models/committee_model.dart',
    'post_model.dart': 'lib/shared/models/post_model.dart',
    'firebase_service.dart': 'lib/shared/data/firebase_service.dart',
    'design_tokens.dart': 'lib/core/constants/design_tokens.dart',
    'app_theme.dart': 'lib/core/theme/app_theme.dart',
    'app_utils.dart': 'lib/core/utils/app_utils.dart',
    'language_switcher.dart': 'lib/core/widgets/language_switcher.dart',
    'locale_provider.dart': 'lib/core/providers/locale_provider.dart',
    'app_localizations.dart': 'lib/l10n/app_localizations.dart',
    'home_screen.dart': 'lib/features/home/presentation/screens/home_screen.dart',
    'feed_screen.dart': 'lib/features/home/presentation/screens/feed_screen.dart',
    'login_screen.dart': 'lib/features/auth/presentation/screens/login_screen.dart',
    'signup_screen.dart': 'lib/features/auth/presentation/screens/signup_screen.dart',
    'welcome_screen.dart': 'lib/features/auth/presentation/screens/welcome_screen.dart',
    'add_announcement_screen.dart': 'lib/features/news/presentation/screens/add_announcement_screen.dart',
    'add_event_screen.dart': 'lib/features/events/presentation/screens/add_event_screen.dart',
}

def get_relative_path(from_file, to_file):
    """Calculate relative path from one file to another"""
    from_path = Path(from_file)
    to_path = Path(to_file)

    try:
        rel_path = os.path.relpath(to_path, from_path.parent)
        return str(rel_path).replace('\\', '/')
    except:
        return None

def fix_imports_in_file(filepath):
    """Fix all imports in a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        original = content

        # Fix each target import
        for filename, target_path in TARGETS.items():
            if not os.path.exists(target_path):
                continue

            # Pattern to match any import of this file
            pattern = rf"import\s+['\"]([^'\"]*{re.escape(filename)})['\"]"

            def replace_import(match):
                current_import = match.group(1)
                # Calculate correct relative path
                correct_path = get_relative_path(filepath, target_path)
                if correct_path:
                    return f"import '{correct_path}'"
                return match.group(0)

            content = re.sub(pattern, replace_import, content)

        if content != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
    except Exception as e:
        print(f"Error in {filepath}: {e}")
    return False

# Process all Dart files
fixed_count = 0
for root, dirs, files in os.walk('lib'):
    # Skip generated files
    if '.dart_tool' in root or 'generated' in root:
        continue

    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            if fix_imports_in_file(filepath):
                fixed_count += 1

print(f"Fixed imports in {fixed_count} files")

