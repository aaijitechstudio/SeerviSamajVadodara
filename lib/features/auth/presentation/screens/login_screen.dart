import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/utils/auth_preferences.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/animations/animated_button.dart';
import '../../../../core/animations/animated_text_field.dart';
import '../../../../core/widgets/responsive_page.dart';
import '../../../../l10n/app_localizations.dart';

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
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Load saved email and remember me preference
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final rememberMe = await AuthPreferences.getRememberMe();
    if (rememberMe) {
      final savedEmail = await AuthPreferences.getSavedEmail();
      if (savedEmail != null && mounted) {
        setState(() {
          _rememberMe = true;
          _emailController.text = savedEmail;
        });
      }
    }
  }

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
        appBar: AppBar(
          title: Text(l10n.login),
          centerTitle: true,
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
                AppColors.primaryOrange.withValues(alpha: 0.1),
                AppColors.backgroundWhite,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              child: ResponsivePage(
                useSafeArea: false,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    SizedBox(
                        height:
                            DesignTokens.spacingXXL + DesignTokens.spacingM),

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
                                  AppColors.backgroundWhite,
                                  AppColors.primaryOrange
                                      .withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(DesignTokens.radiusXL),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryOrange
                                      .withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(DesignTokens.spacingS),
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
                          SizedBox(height: DesignTokens.spacingL),
                          Text(
                            l10n.welcomeBack,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: DesignTokens.spacingS),
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

                    SizedBox(height: DesignTokens.spacingXXL),

                    // Email Field
                    AnimatedTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: l10n.email,
                      prefixIcon: Icons.email_outlined,
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

                    SizedBox(height: DesignTokens.spacingM),

                    // Password Field
                    AnimatedTextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      labelText: l10n.password,
                      prefixIcon: Icons.lock_outlined,
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

                    SizedBox(height: DesignTokens.spacingS),

                    // Remember Me and Forgot Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember Me Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: AppColors.primaryOrange,
                            ),
                            Text(
                              LocalizationFallbacks.rememberMe(l10n),
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeS,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        // Forgot Password Link
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/forgot-password');
                          },
                          child: Text(
                            l10n.forgotPassword,
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: DesignTokens.fontWeightMedium,
                              fontSize: DesignTokens.fontSizeS,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: DesignTokens.spacingM),

                    // Login Button
                    Consumer(
                      builder: (context, ref, child) {
                        final authState = ref.watch(authControllerProvider);
                        return AnimatedButton(
                          onPressed: authState.isLoading ? null : _handleLogin,
                          isLoading: authState.isLoading,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: DesignTokens.spacingM),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(l10n.signIn),
                        );
                      },
                    ),

                    SizedBox(height: DesignTokens.spacingM),

                    // Divider with "OR"
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingM),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),

                    SizedBox(height: DesignTokens.spacingM),

                    // Google Sign In Button (Standard Design)
                    Consumer(
                      builder: (context, ref, child) {
                        final authState = ref.watch(authControllerProvider);
                        return GoogleSignInButton(
                          onPressed: _handleGoogleSignIn,
                          isLoading: authState.isGoogleSignInLoading,
                        );
                      },
                    ),

                    SizedBox(height: DesignTokens.spacingM),

                    // Error Message
                    Consumer(
                      builder: (context, ref, child) {
                        final authState = ref.watch(authControllerProvider);
                        if (authState.error != null) {
                          return Container(
                            padding:
                                const EdgeInsets.all(DesignTokens.spacingM),
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

                    SizedBox(height: DesignTokens.spacingM),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.dontHaveAccount),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/signup');
                          },
                          child: Text(l10n.signUp),
                        ),
                      ],
                    ),

                    SizedBox(height: DesignTokens.spacingM),

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
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _openUrl('https://example.com/terms'),
                            child: Text(
                              l10n.termsAndConditions,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeS,
                                color: AppColors.primaryOrange,
                                fontWeight: DesignTokens.fontWeightMedium,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            ' ${l10n.and} ',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeS,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _openUrl('https://example.com/privacy'),
                            child: Text(
                              l10n.privacyPolicy,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeS,
                                color: AppColors.primaryOrange,
                                fontWeight: DesignTokens.fontWeightMedium,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: DesignTokens.spacingL),

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
                              AppColors.textSecondary,
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
        ),
      );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final authController = ref.read(authControllerProvider.notifier);

    // Save remember me preference
    await AuthPreferences.setRememberMe(_rememberMe);
    if (_rememberMe) {
      await AuthPreferences.saveEmail(email);
    } else {
      await AuthPreferences.clearSavedEmail();
    }

    final success = await authController.signIn(
      email: email,
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Log login activity
      await AuthPreferences.addLoginActivity(
        email: email,
        timestamp: DateTime.now(),
        method: 'email',
      );

      // AuthGate will route to the correct screen on successful login.
    } else if (mounted) {
      // Check for error in auth state
      final authState = ref.read(authControllerProvider);
      if (authState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authController = ref.read(authControllerProvider.notifier);

    final success = await authController.signInWithGoogle();

    if (success && mounted) {
      // Log login activity
      final authState = ref.read(authControllerProvider);
      final email = authState.user?.email ?? 'google_user';
      await AuthPreferences.addLoginActivity(
        email: email,
        timestamp: DateTime.now(),
        method: 'google',
      );

      // AuthGate will route to the correct screen on successful login.
    } else if (mounted) {
      // Check for error in auth state
      final authState = ref.read(authControllerProvider);
      if (authState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
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
