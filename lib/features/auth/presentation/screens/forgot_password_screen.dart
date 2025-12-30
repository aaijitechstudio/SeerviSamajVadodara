import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/responsive_page.dart';
import '../../../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = ref.read(authControllerProvider.notifier);
    final success = await authController.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
      AppUtils.showSuccessSnackBar(
        context,
        AppLocalizations.of(context)!.passwordResetEmailSent,
      );
    } else if (mounted) {
      final error = ref.read(authControllerProvider).error;
      if (error != null) {
        AppUtils.showErrorSnackBar(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.forgotPasswordTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          child: ResponsivePage(
            useSafeArea: false,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                if (!_emailSent) ...[
                  const SizedBox(height: DesignTokens.spacingXL),
                  Icon(
                    Icons.lock_reset,
                    size: DesignTokens.iconSizeXL,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(height: DesignTokens.spacingL),
                  Text(
                    l10n.resetYourPassword,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeH4,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.spacingM),
                  Text(
                    l10n.resetPasswordDescription,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeM,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.spacingXL),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      hintText: l10n.enterYourEmail,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusM,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterYourEmail;
                      }
                      if (!AppUtils.isValidEmail(value)) {
                        return l10n.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingXL),
                  ElevatedButton(
                    onPressed:
                        authState.isLoading ? null : _sendPasswordResetEmail,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingM,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusM,
                        ),
                      ),
                    ),
                    child: authState.isLoading
                        ? const ButtonLoader()
                        : Text(l10n.sendResetLink),
                  ),
                ] else ...[
                  const SizedBox(height: DesignTokens.spacingXL),
                  Icon(
                    Icons.check_circle,
                    size: DesignTokens.iconSizeXL,
                    color: AppColors.successColor,
                  ),
                  const SizedBox(height: DesignTokens.spacingL),
                  Text(
                    l10n.emailSent,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeH4,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.spacingM),
                  Text(
                    l10n.emailSentDescription(_emailController.text.trim()),
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeM,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.spacingXL),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(), // back to Login
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: DesignTokens.spacingM,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusM,
                        ),
                      ),
                    ),
                    child: Text(l10n.backToLogin),
                  ),
                ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
