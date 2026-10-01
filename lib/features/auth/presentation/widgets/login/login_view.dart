import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/core/widget/app_text_field.dart';
import 'package:smart_tani_mobile/core/widget/primary_button.dart';
import 'package:smart_tani_mobile/features/auth/components/social_login_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    required this.formKey,
    required this.loginController,
    required this.passwordController,
    required this.isLoading,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
    required this.onValidateLogin,
    required this.onValidatePassword,
    required this.onForgotPassword,
    required this.onGoogleLogin,
    required this.onAppleLogin,
    required this.onGoToRegister,
    super.key,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController loginController;
  final TextEditingController passwordController;

  final bool isLoading;
  final bool isPasswordVisible;

  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onGoogleLogin;
  final VoidCallback onAppleLogin;
  final VoidCallback onGoToRegister;

  final String? Function(String?) onValidateLogin;
  final String? Function(String?) onValidatePassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              const Positioned(
                left: -14,
                bottom: -8,
                child: Icon(
                  Icons.eco,
                  size: 82,
                  color: AppColors.primaryLight,
                ),
              ),
              const Positioned(
                right: -14,
                bottom: -8,
                child: Icon(
                  Icons.eco,
                  size: 82,
                  color: AppColors.primaryLight,
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/smart_tani_2.png',
                          filterQuality: FilterQuality.high,
                          width: 250,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Masuk ke Akun Anda',
                        style: AppTypography.headingLarge
                            .copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Lanjutkan perjalanan pertanian Anda',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: loginController,
                        label: 'Email atau nomor HP',
                        keyboardType:
                            TextInputType.emailAddress,
                        textInputAction:
                            TextInputAction.next,
                        enabled: !isLoading,
                        autofillHints: const [
                          AutofillHints.username,
                        ],
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                        ),
                        validator: onValidateLogin,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: !isPasswordVisible,
                        textInputAction:
                            TextInputAction.done,
                        enabled: !isLoading,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                          onPressed: isLoading
                              ? null
                              : onTogglePasswordVisibility,
                          icon: Icon(
                            isPasswordVisible
                                ? Icons
                                      .visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        validator: onValidatePassword,
                        onFieldSubmitted: (_) {
                          if (!isLoading) {
                            onSubmit();
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : onForgotPassword,
                          child: const Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // if (errorMessage != null) ...[
                      //   const SizedBox(
                      //     height: AppSpacing.sm,
                      //   ),
                      //   Container(
                      //     width: double.infinity,
                      //     padding:
                      //         const EdgeInsets.symmetric(
                      //           horizontal: AppSpacing.md,
                      //           vertical: AppSpacing.sm,
                      //         ),
                      //     decoration: BoxDecoration(
                      //       color: AppColors.error
                      //           .withValues(alpha: 0.08),
                      //       borderRadius:
                      //           BorderRadius.circular(12),
                      //       border: Border.all(
                      //         color: AppColors.error
                      //             .withValues(alpha: 0.2),
                      //       ),
                      //     ),
                      //     child: Text(
                      //       errorMessage!,
                      //       style: const TextStyle(
                      //         color: AppColors.error,
                      //         fontSize: 13,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      const SizedBox(height: AppSpacing.md),
                      PrimaryButton(
                        label: 'Masuk',
                        isLoading: isLoading,
                        onPressed: onSubmit,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Center(
                        child: Text(
                          'atau masuk dengan',
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: SocialLoginButton(
                              label: 'Google',
                              iconPath:
                                  'assets/icons/google.svg',
                              onPressed: isLoading
                                  ? null
                                  : onGoogleLogin,
                            ),
                          ),
                          const SizedBox(
                            width: AppSpacing.sm,
                          ),
                          Expanded(
                            child: SocialLoginButton(
                              label: 'Apple',
                              iconPath:
                                  'assets/icons/apple.svg',
                              onPressed: isLoading
                                  ? null
                                  : onAppleLogin,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun?',
                            style: AppTypography.bodyMedium,
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : onGoToRegister,
                            child: const Text(
                              'Daftar sekarang',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
