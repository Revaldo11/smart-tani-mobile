import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/app/routes/route_names.dart';
import 'package:smart_tani_mobile/core/widget/app_custom_dialog.dart';

import '../providers/register_form_provider.dart';
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

  void _goToLogin(RegisterFormProvider auth) {
    auth.clearError();
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<RegisterFormProvider>();

    return RegisterView(
      formKey: auth.formKey,
      nameController: auth.nameController,
      emailController: auth.emailController,
      phoneController: auth.phoneController,
      passwordController: auth.passwordController,
      confirmPasswordController:
          auth.confirmPasswordController,
      isLoading: auth.isLoading,
      isPasswordVisible: auth.passwordVisible,
      isConfirmPasswordVisible: auth.confirmPasswordVisible,
      termsAccepted: auth.termsAccepted,
      onBack: () {
        _goToLogin(auth);
      },
      onTogglePasswordVisibility:
          auth.togglePasswordVisibility,
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
