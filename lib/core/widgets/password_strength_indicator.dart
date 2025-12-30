import 'package:flutter/material.dart';
import '../utils/password_validator.dart';
import '../theme/app_colors.dart';
import '../constants/design_tokens.dart';

/// Password strength indicator widget
/// Shows visual feedback for password strength
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool showSuggestions;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showSuggestions = true,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final strength = PasswordValidator.calculateStrength(password);
    final percentage = PasswordValidator.getStrengthPercentage(strength);
    final description = PasswordValidator.getStrengthDescription(strength);
    final color = Color(PasswordValidator.getStrengthColor(strength));
    final suggestions = PasswordValidator.getSuggestions(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: AppColors.grey200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingS),
            Text(
              description,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeS,
                fontWeight: DesignTokens.fontWeightMedium,
                color: color,
              ),
            ),
          ],
        ),

        // Suggestions
        if (showSuggestions && suggestions.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingXS),
          ...suggestions.take(3).map((suggestion) => Padding(
                padding: const EdgeInsets.only(
                  left: DesignTokens.spacingM,
                  top: DesignTokens.spacingXS,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: DesignTokens.spacingXS),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSizeXS,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ],
    );
  }
}

