import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/app/routes/route_names.dart';
import 'package:smart_tani_mobile/core/widget/app_custom_dialog.dart';

import '../providers/auth_provider.dart';
import '../widgets/register/register_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> _showRegisterSuccessDialogPreview() async {
    await showAppCustomDialog<void>(
      context,
      title: 'Akun Berhasil Dibuat!',
      description:
          'Akun Smart Tani Anda sudah siap. Tambahkan lahan pertama Anda sekarang untuk mulai mengelola aktivitas pertanian.',
      primaryLabel: 'Tambah Lahan Sekarang',
      secondaryLabel: 'Lewati untuk Sekarang',
      barrierDismissible: false,
      onPrimaryPressed: () {
        Navigator.of(context).pop();
      },
      onSecondaryPressed: () {
        Navigator.of(context).pop();
        context.go(RouteNames.login);
      },
      imagePath: 'assets/images/sobat_tani.png',
    );
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
        _showRegisterSuccessDialogPreview();
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
