import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogo;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showLogo = true,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      shape: Border(
        bottom: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : AppColors.borderLight,
          width: 1,
        ),
      ),
      title: showLogo
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Logo
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : AppColors.shadowLight,
                        blurRadius: DesignTokens.elevationLow,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    child: Image.asset(
                      'assets/images/samaj_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.people,
                          size: DesignTokens.iconSizeM,
                          color: isDark
                              ? AppColors.accentGold
                              : AppColors.primaryOrange,
                        );
                      },
                    ),
                  ),
                ),
                if (title != null) ...[
                  const SizedBox(width: DesignTokens.spacingS),
                  // App Title
                  Flexible(
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeH6,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        color: isDark ? Colors.white : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: DesignTokens.spacingS),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          l10n.samajTitle,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeH6,
                            fontWeight: DesignTokens.fontWeightSemiBold,
                            color: isDark ? Colors.white : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          l10n.samajVadodara,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeS,
                            fontWeight: DesignTokens.fontWeightMedium,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.8)
                                : AppColors.primaryOrangeDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            )
          : title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: isDark ? Colors.white : null,
                  ),
                )
              : null,
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
