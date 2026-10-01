import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/app/routes/route_names.dart';
import 'package:smart_tani_mobile/core/widget/global_snackbar.dart';

import '../providers/auth_provider.dart';
import '../widgets/register/register_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> _handleRegisterSubmit(
    AuthProvider auth,
  ) async {
    await auth.submitRegister();

    if (!mounted) return;

    final error = auth.errorMessage;

    if (error != null && error.trim().isNotEmpty) {
      showGlobalSnackbar(
        context,
        title: 'Gagal',
        subtitle: error,
        mode: SnackBarMode.failure,
      );
    }
  }

  void _goToLogin(AuthProvider auth) {
    auth.clearError();
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return RegisterView(
      formKey: auth.registerFormKey,
      nameController: auth.nameController,
      emailController: auth.emailController,
      phoneController: auth.phoneController,
      passwordController: auth.registerPasswordController,
      confirmPasswordController:
          auth.confirmPasswordController,
      isLoading: auth.isLoading,
      isPasswordVisible: auth.registerPasswordVisible,
      isConfirmPasswordVisible: auth.confirmPasswordVisible,
      termsAccepted: auth.termsAccepted,
      onBack: () {
        _goToLogin(auth);
      },
      onTogglePasswordVisibility:
          auth.toggleRegisterPasswordVisibility,
      onToggleConfirmPasswordVisibility:
          auth.toggleConfirmPasswordVisibility,
      onTermsChanged: auth.setTermsAccepted,
      onSubmit: () {
        _handleRegisterSubmit(auth);
      },
      onGoToLogin: () {
        _goToLogin(auth);
      },
      onValidateName: (value) {
        return auth.validateRequired(value, 'Nama lengkap');
      },
      onValidateEmail: auth.validateEmail,
      onValidatePhone: auth.validatePhone,
      onValidatePassword: auth.validatePassword,
      onValidatePasswordConfirmation:
          auth.validatePasswordConfirmation,
    );
  }
}
