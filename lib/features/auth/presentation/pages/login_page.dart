import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/app/routes/route_names.dart';
import 'package:smart_tani_mobile/core/widget/app_text_field.dart';
import 'package:smart_tani_mobile/core/widget/primary_button.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: auth.loginFormKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxl),

                  const Text(
                    'Selamat Datang',
                    style: AppTypography.headingLarge,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  const Text(
                    'Masuk untuk melanjutkan ke Smart Tani.',
                    style: AppTypography.bodyMedium,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  AppTextField(
                    controller: auth.loginController,
                    label: 'Email atau Nomor HP',
                    hint: 'Masukkan email atau nomor HP',
                    keyboardType:
                        TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !auth.isLoading,
                    autofillHints: const [
                      AutofillHints.username,
                    ],
                    prefixIcon: const Icon(
                      Icons.person_outline,
                    ),
                    validator: (value) {
                      return auth.validateRequired(
                        value,
                        'Email atau nomor HP',
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    controller:
                        auth.loginPasswordController,
                    label: 'Password',
                    hint: 'Masukkan password',
                    obscureText: !auth.loginPasswordVisible,
                    textInputAction: TextInputAction.done,
                    enabled: !auth.isLoading,
                    autofillHints: const [
                      AutofillHints.password,
                    ],
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      onPressed: auth.isLoading
                          ? null
                          : auth.toggleLoginPasswordVisibility,
                      icon: Icon(
                        auth.loginPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                    validator: (value) {
                      return auth.validateRequired(
                        value,
                        'Password',
                      );
                    },
                    onFieldSubmitted: (_) {
                      if (!auth.isLoading) {
                        auth.submitLogin();
                      }
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  PrimaryButton(
                    label: 'Masuk',
                    isLoading: auth.isLoading,
                    onPressed: auth.submitLogin,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: AppTypography.bodyMedium,
                      ),
                      TextButton(
                        onPressed: auth.isLoading
                            ? null
                            : () {
                                auth.clearError();

                                context.push(
                                  RouteNames.register,
                                );
                              },
                        child: const Text('Daftar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
