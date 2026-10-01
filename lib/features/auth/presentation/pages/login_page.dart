import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/app/routes/route_names.dart';
import 'package:smart_tani_mobile/core/widget/global_snackbar.dart';
import '../providers/auth_provider.dart';
import '../widgets/login/login_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleLoginSubmit(AuthProvider auth) async {
    await auth.submitLogin();

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
    final auth = context.watch<AuthProvider>();

    return LoginView(
      formKey: auth.loginFormKey,
      loginController: auth.loginController,
      passwordController: auth.loginPasswordController,
      isLoading: auth.isLoading,
      isPasswordVisible: auth.loginPasswordVisible,
      onTogglePasswordVisibility:
          auth.toggleLoginPasswordVisibility,
      onSubmit: () {
        _handleLoginSubmit(auth);
      },
      onValidateLogin: auth.validateLogin,
      onValidatePassword: (value) {
        return auth.validateRequired(value, 'Password');
      },
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
        auth.clearError();
        context.push(RouteNames.register);
      },
    );
  }
}
