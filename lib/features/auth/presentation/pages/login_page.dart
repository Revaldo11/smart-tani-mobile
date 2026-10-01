import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/app/routes/route_names.dart';
import 'package:smart_tani_mobile/core/widget/global_snackbar.dart';
import '../providers/login_form_provider.dart';
import '../widgets/login/login_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleLoginSubmit(
    LoginFormProvider auth,
  ) async {
    await auth.submit();

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

  void _showFeatureComingSoon(String featureName) {
    showGlobalSnackbar(
      context,
      title: 'Informasi',
      subtitle: 'Fitur ini akan segera tersedia.',
      mode: SnackBarMode.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<LoginFormProvider>();

    return LoginView(
      formKey: auth.formKey,
      loginController: auth.loginController,
      passwordController: auth.passwordController,
      isLoading: auth.isLoading,
      isPasswordVisible: auth.passwordVisible,
      onTogglePasswordVisibility:
          auth.togglePasswordVisibility,
      onSubmit: () {
        _handleLoginSubmit(auth);
      },
      onValidateLogin: auth.validateLogin,
      onValidatePassword: auth.validatePassword,
      onForgotPassword: () {
        _showFeatureComingSoon('Fitur lupa password');
      },
      onGoogleLogin: () {
        _showFeatureComingSoon('Masuk dengan Google');
      },
      onAppleLogin: () {
        _showFeatureComingSoon('Masuk dengan Apple');
      },
      onGoToRegister: () {
        auth.resetFormState();
        context.push(RouteNames.register);
      },
    );
  }
}
