import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/validators/auth_validators.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_session_provider.dart';

class RegisterFormProvider extends ChangeNotifier {
  RegisterFormProvider(
    this._repository,
    this._sessionProvider,
  );

  final AuthRepository _repository;
  final AuthSessionProvider _sessionProvider;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _termsAccepted = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get passwordVisible => _passwordVisible;
  bool get confirmPasswordVisible =>
      _confirmPasswordVisible;
  bool get termsAccepted => _termsAccepted;

  Future<bool> submit({bool validateForm = true}) async {
    clearError();

    if (validateForm) {
      final isValid =
          formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return false;
      }
    }

    if (!_termsAccepted) {
      _errorMessage =
          'Anda harus menyetujui Syarat & Ketentuan.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final user = await _repository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        passwordConfirmation:
            confirmPasswordController.text,
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

  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  String? validateRequired(String? value, String field) {
    return AuthValidators.required(value, field);
  }

  String? validateEmail(String? value) {
    return AuthValidators.email(value);
  }

  String? validatePhone(String? value) {
    return AuthValidators.phone(value);
  }

  String? validatePassword(String? value) {
    return AuthValidators.password(value);
  }

  String? validatePasswordConfirmation(String? value) {
    return AuthValidators.passwordConfirmation(
      value,
      passwordController.text,
    );
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    _passwordVisible = false;
    _confirmPasswordVisible = false;
    _termsAccepted = false;
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
