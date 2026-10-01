import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/validators/auth_validators.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_session_provider.dart';

class LoginFormProvider extends ChangeNotifier {
  LoginFormProvider(
    this._repository,
    this._sessionProvider,
  );

  final AuthRepository _repository;
  final AuthSessionProvider _sessionProvider;

  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;
  bool _passwordVisible = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get passwordVisible => _passwordVisible;

  Future<bool> submit({
    bool validateForm = true,
    bool addDemoDelay = true,
  }) async {
    clearError();

    if (validateForm) {
      final isValid =
          formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return false;
      }
    }

    _setLoading(true);

    try {
      if (addDemoDelay) {
        await Future.delayed(const Duration(seconds: 5));
      }

      final user = await _repository.login(
        login: loginController.text.trim(),
        password: passwordController.text,
      );

      _sessionProvider.setAuthenticated(user);
      clearForm();

      return true;
    } on AppException catch (error) {
      _setError(error.message);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  String? validateLogin(String? value) {
    return AuthValidators.login(value);
  }

  String? validatePassword(String? value) {
    return AuthValidators.required(value, 'Password');
  }

  void clearForm() {
    loginController.clear();
    passwordController.clear();
    _passwordVisible = false;
  }

  void resetFormState() {
    formKey.currentState?.reset();
    clearForm();

    if (_errorMessage != null) {
      _errorMessage = null;
    }

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
