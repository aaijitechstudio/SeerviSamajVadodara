import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../../../home/presentation/screens/main_navigation_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        showLogo: false,
        title: l10n.login,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: const [LanguageSwitcher()],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DesignTokens.primaryOrange.withValues(alpha: 0.1),
              DesignTokens.backgroundWhite,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  // Logo and Title
                  Center(
                    child: Column(
                      children: [
                        // Samaj Logo with Enhanced Design (same as welcome screen)
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                DesignTokens.backgroundWhite,
                                DesignTokens.primaryOrange
                                    .withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(DesignTokens.radiusXL),
                            boxShadow: [
                              BoxShadow(
                                color: DesignTokens.primaryOrange
                                    .withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: DesignTokens.shadowLight,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(DesignTokens.radiusL),
                              child: Image.asset(
                                'assets/images/seervisamajvadodara.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.people,
                                    size: DesignTokens.iconSizeXL,
                                    color: Theme.of(context).primaryColor,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.welcomeBack,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.signInToYourAccount,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterEmail;
                      }
                      if (!AppUtils.isValidEmail(value)) {
                        return l10n.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterPassword;
                      }
                      if (value.length < 6) {
                        return l10n.passwordMustBeAtLeast6;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.forgotPassword,
                        style: TextStyle(
                          color: DesignTokens.primaryOrange,
                          fontWeight: DesignTokens.fontWeightMedium,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Login Button
                  Consumer(
                    builder: (context, ref, child) {
                      final authState = ref.watch(authControllerProvider);
                      return ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        child: authState.isLoading
                            ? const ButtonLoader()
                            : Text(l10n.signIn),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Error Message
                  Consumer(
                    builder: (context, ref, child) {
                      final authState = ref.watch(authControllerProvider);
                      if (authState.error != null) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            authState.error!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 16),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.dontHaveAccount),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: Text(l10n.signUp),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Terms and Privacy Policy
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '${l10n.bySigningInYouAgreeTo} ',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeS,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openUrl('https://example.com/terms'),
                          child: Text(
                            l10n.termsAndConditions,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeS,
                              color: DesignTokens.primaryOrange,
                              fontWeight: DesignTokens.fontWeightMedium,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          ' ${l10n.and} ',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeS,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openUrl('https://example.com/privacy'),
                          child: Text(
                            l10n.privacyPolicy,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeS,
                              color: DesignTokens.primaryOrange,
                              fontWeight: DesignTokens.fontWeightMedium,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Powered By Footer
                  Center(
                    child: Text(
                      'Powered by - Seervi Kshatriya Samaj - Vadodara',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXS,
                        color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.6) ??
                            DesignTokens.textSecondary,
                        fontWeight: DesignTokens.fontWeightRegular,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = ref.read(authControllerProvider.notifier);

    final success = await authController.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $url'),
          ),
        );
      }
    }
  }
}
