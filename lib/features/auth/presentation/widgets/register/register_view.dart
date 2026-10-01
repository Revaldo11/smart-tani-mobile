import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/core/theme/app_typography.dart';
import 'package:smart_tani_mobile/core/widget/app_text_field.dart';
import 'package:smart_tani_mobile/core/widget/primary_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.termsAccepted,
    required this.onBack,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onTermsChanged,
    required this.onSubmit,
    required this.onGoToLogin,
    required this.onValidateName,
    required this.onValidateEmail,
    required this.onValidatePhone,
    required this.onValidatePassword,
    required this.onValidatePasswordConfirmation,
    super.key,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool termsAccepted;

  final VoidCallback onBack;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;

  final String? Function(String?) onValidateName;
  final String? Function(String?) onValidateEmail;
  final String? Function(String?) onValidatePhone;
  final String? Function(String?) onValidatePassword;
  final String? Function(String?)
  onValidatePasswordConfirmation;

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
                left: -18,
                bottom: -10,
                child: Icon(
                  Icons.local_florist,
                  size: 88,
                  color: AppColors.primaryLight,
                ),
              ),
              const Positioned(
                right: -18,
                bottom: -10,
                child: Icon(
                  Icons.local_florist,
                  size: 88,
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
                        CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: isLoading
                            ? null
                            : onBack,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppColors.surface,
                          side: const BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'Buat Akun Baru',
                        style: AppTypography.headingLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Daftar dan mulai kelola pertanian Anda',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: nameController,
                        label: 'Nama Lengkap',
                        textInputAction:
                            TextInputAction.next,
                        enabled: !isLoading,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                        ),
                        validator: onValidateName,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: emailController,
                        label: 'Email',
                        keyboardType:
                            TextInputType.emailAddress,
                        textInputAction:
                            TextInputAction.next,
                        enabled: !isLoading,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                        ),
                        validator: onValidateEmail,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: phoneController,
                        label: 'Nomor HP',
                        keyboardType: TextInputType.phone,
                        textInputAction:
                            TextInputAction.next,
                        enabled: !isLoading,
                        autofillHints: const [
                          AutofillHints.telephoneNumber,
                        ],
                        prefixIcon: const Icon(
                          Icons.phone_iphone_outlined,
                        ),
                        validator: onValidatePhone,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: !isPasswordVisible,
                        textInputAction:
                            TextInputAction.next,
                        enabled: !isLoading,
                        autofillHints: const [
                          AutofillHints.newPassword,
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
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller:
                            confirmPasswordController,
                        label: 'Konfirmasi Password',
                        obscureText:
                            !isConfirmPasswordVisible,
                        textInputAction:
                            TextInputAction.done,
                        enabled: !isLoading,
                        autofillHints: const [
                          AutofillHints.newPassword,
                        ],
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                          onPressed: isLoading
                              ? null
                              : onToggleConfirmPasswordVisibility,
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons
                                      .visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        validator:
                            onValidatePasswordConfirmation,
                        onFieldSubmitted: (_) {
                          if (!isLoading) {
                            onSubmit();
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      InkWell(
                        onTap: isLoading
                            ? null
                            : () {
                                onTermsChanged(
                                  !termsAccepted,
                                );
                              },
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                              ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: termsAccepted,
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        onTermsChanged(
                                          value ?? false,
                                        );
                                      },
                                activeColor:
                                    AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        6,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                width: AppSpacing.sm,
                              ),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: AppTypography
                                        .bodyMedium,
                                    children: [
                                      TextSpan(
                                        text:
                                            'Saya menyetujui ',
                                        style: TextStyle(
                                          color: AppColors
                                              .textPrimary,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Syarat & Ketentuan',
                                        style: TextStyle(
                                          color: AppColors
                                              .primary,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' dan ',
                                        style: TextStyle(
                                          color: AppColors
                                              .textPrimary,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Kebijakan Privasi',
                                        style: TextStyle(
                                          color: AppColors
                                              .primary,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PrimaryButton(
                        label: 'Daftar',
                        isLoading: isLoading,
                        onPressed: onSubmit,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah punya akun?',
                            style: AppTypography.bodyMedium,
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : onGoToLogin,
                            child: const Text(
                              'Masuk',
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
