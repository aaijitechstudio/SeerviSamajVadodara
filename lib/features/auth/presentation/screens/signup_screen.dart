import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/data/firebase_service.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _gotraController = TextEditingController();
  final _vadodaraAddressController = TextEditingController();
  final _nativeAddressController = TextEditingController();
  final _pratisthanNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _gotraController.dispose();
    _vadodaraAddressController.dispose();
    _nativeAddressController.dispose();
    _pratisthanNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        showLogo: false,
        title: l10n.signUp,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          child: Column(
            children: [
              // Step Indicator
              _buildStepIndicator(l10n),

              // Form Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStep1(l10n),
                      _buildStep2(l10n),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStepItem(
              stepNumber: 1,
              label: l10n.basicInformation,
              isActive: _currentStep == 0,
              isCompleted: _currentStep > 0,
            ),
          ),
          Container(
            width: 40,
            height: 2,
            color: _currentStep > 0
                ? DesignTokens.primaryOrange
                : DesignTokens.grey300,
          ),
          Expanded(
            child: _buildStepItem(
              stepNumber: 2,
              label: l10n.additionalInformation,
              isActive: _currentStep == 1,
              isCompleted: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int stepNumber,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCompleted
                ? DesignTokens.primaryOrange
                : DesignTokens.grey300,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: DesignTokens.textOnPrimary,
                    size: 20,
                  )
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: isActive || isCompleted
                          ? DesignTokens.textOnPrimary
                          : DesignTokens.grey600,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeS,
            color: isActive
                ? DesignTokens.primaryOrange
                : DesignTokens.textSecondary,
            fontWeight: isActive
                ? DesignTokens.fontWeightBold
                : DesignTokens.fontWeightRegular,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStep1(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Profile Image Section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: DesignTokens.primaryOrange,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: DesignTokens.primaryOrange
                                  .withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _profileImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      DesignTokens.primaryOrange
                                          .withValues(alpha: 0.1),
                                      DesignTokens.primaryOrange
                                          .withValues(alpha: 0.3),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_add,
                                  size: 50,
                                  color: DesignTokens.primaryOrange,
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: DesignTokens.primaryOrange,
                            border: Border.all(
                              color: DesignTokens.backgroundWhite,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: DesignTokens.textOnPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.profileImage,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSizeM,
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Name Field
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.fullName,
              prefixIcon: const Icon(Icons.person_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterFullName;
              }
              if (value.length < 2) {
                return l10n.nameMustBeAtLeast2;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

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

          // Phone Field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.phoneNumber,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterPhone;
              }
              if (!AppUtils.isValidPhone(value)) {
                return l10n.pleaseEnterValidPhone;
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
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
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

          const SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: l10n.confirmPassword,
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseConfirmPassword;
              }
              if (value != _passwordController.text) {
                return l10n.passwordsDoNotMatch;
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Next Button
          AppButton(
            label: l10n.next,
            icon: Icons.arrow_forward,
            onPressed: _goToStep2,
          ),

          const SizedBox(height: 16),

          // Sign In Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${l10n.alreadyHaveAccount} "),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(l10n.signIn),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Gotra Field
          TextFormField(
            controller: _gotraController,
            decoration: InputDecoration(
              labelText: l10n.gotra,
              prefixIcon: const Icon(Icons.family_restroom),
              hintText: l10n.pleaseEnterGotra,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterGotra;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Vadodara Address Field
          TextFormField(
            controller: _vadodaraAddressController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.vadodaraAddress,
              prefixIcon: const Icon(Icons.location_on),
              hintText: l10n.pleaseEnterVadodaraAddress,
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterVadodaraAddress;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Native Address Field
          TextFormField(
            controller: _nativeAddressController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.nativeAddress,
              prefixIcon: const Icon(Icons.home),
              hintText: l10n.pleaseEnterNativeAddress,
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterNativeAddress;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Pratisthan Name Field
          TextFormField(
            controller: _pratisthanNameController,
            decoration: InputDecoration(
              labelText: l10n.pratisthanName,
              prefixIcon: const Icon(Icons.business),
              hintText: l10n.pleaseEnterPratisthanName,
            ),
          ),

          const SizedBox(height: 24),

          // Terms and Conditions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _agreeToTerms = !_agreeToTerms;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      l10n.iAgreeToTerms,
                      style: const TextStyle(fontSize: DesignTokens.fontSizeM),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Error Message
          Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authControllerProvider);
              if (authState.error != null) {
                final isEmailInUse = authState.error!
                        .toLowerCase()
                        .contains('already registered') ||
                    authState.error!.toLowerCase().contains('email is already');
                return Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.errorBackground,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    border: Border.all(color: AppColors.errorBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.error!,
                        style: const TextStyle(color: AppColors.errorText),
                      ),
                      if (isEmailInUse) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            l10n.goToSignIn,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: DesignTokens.fontWeightBold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 16),

          // Previous and Sign Up Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.previous,
                  type: AppButtonType.secondary,
                  icon: Icons.arrow_back,
                  onPressed: _goToStep1,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authControllerProvider);
                    return AppButton(
                      label: l10n.signUp,
                      isLoading: authState.isLoading,
                      onPressed: (!_agreeToTerms || authState.isLoading)
                          ? null
                          : _handleSignUp,
                      isFullWidth: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _goToStep2() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = 1;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToStep1() {
    setState(() {
      _currentStep = 0;
    });
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.selectFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.errorText),
                title: Text(
                  AppLocalizations.of(context)!.removeImage,
                  style: const TextStyle(color: AppColors.errorText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _profileImage = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppUtils.showErrorSnackBar(
        context,
        'Failed to pick image: $e',
      );
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      final l10n = AppLocalizations.of(context)!;
      AppUtils.showErrorSnackBar(context, l10n.pleaseAgreeToTerms);
      return;
    }

    final authController = ref.read(authControllerProvider.notifier);

    // First, sign up the user (without profile image)
    final success = await authController.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      gotra: _gotraController.text.trim(),
      vadodaraAddress: _vadodaraAddressController.text.trim(),
      nativeAddress: _nativeAddressController.text.trim(),
      pratisthanName: _pratisthanNameController.text.trim(),
      profileImageUrl: null, // Upload image after signup
    );

    if (!success || !mounted) return;

    // Get user ID to show in snackbar
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id ?? '';
    final samajId = authState.user?.samajId;
    final displayId = samajId ?? userId;

    // Upload profile image after user is authenticated
    if (_profileImage != null) {
      try {
        final imageBytes = await _profileImage!.readAsBytes();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final profileImageUrl = await FirebaseService.uploadImage(
          'users/profile_images/$fileName',
          imageBytes,
        );

        // Update user profile with image URL
        if (mounted) {
          await authController.updateProfile(
            profileImageUrl: profileImageUrl,
          );
        }
      } catch (e) {
        // Don't block navigation if image upload fails
        if (mounted) {
          AppUtils.showErrorSnackBar(
            context,
            'Profile created but image upload failed. You can update it later.',
          );
        }
      }
    }

    if (mounted) {
      // Show user ID in top snackbar
      final l10n = AppLocalizations.of(context)!;
      AppUtils.showTopSnackBar(
        context,
        '${l10n.signUpSuccess} - ${l10n.userId}: $displayId',
        backgroundColor: Colors.green,
      );

      // Navigate to login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
