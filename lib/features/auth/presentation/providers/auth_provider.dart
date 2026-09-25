import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/features/auth/data/model/user_model.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Login
  final loginController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final registerPasswordController =
      TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _termsAccepted = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == AuthStatus.loading;

  bool get loginPasswordVisible => _loginPasswordVisible;
  bool get registerPasswordVisible =>
      _registerPasswordVisible;
  bool get confirmPasswordVisible =>
      _confirmPasswordVisible;
  bool get termsAccepted => _termsAccepted;

  Future<void> submitLogin() async {
    clearError();

    final isValid =
        loginFormKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _setLoading();

    try {
      _user = await _repository.login(
        login: loginController.text.trim(),
        password: loginPasswordController.text,
      );

      _status = AuthStatus.authenticated;

      clearLoginForm();
    } on AppException catch (error) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = error.message;
    }

    notifyListeners();
  }

  Future<void> submitRegister() async {
    clearError();

    final isValid =
        registerFormKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (!_termsAccepted) {
      _errorMessage =
          'Anda harus menyetujui Syarat & Ketentuan.';

      notifyListeners();
      return;
    }

    _setLoading();

    try {
      _user = await _repository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: registerPasswordController.text,
        passwordConfirmation:
            confirmPasswordController.text,
      );

      _status = AuthStatus.authenticated;

      clearRegisterForm();
    } on AppException catch (error) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = error.message;
    }

    notifyListeners();
  }

  // =========================================================
  // SESSION
  // =========================================================

  Future<void> initializeSession() async {
    final hasToken = await _repository.hasToken();

    if (!hasToken) {
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      _user = await _repository.getCurrentUser();

      _status = AuthStatus.authenticated;
    } catch (_) {
      await _repository.clearSession();

      _user = null;
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // =========================================================
  // LOGIN
  // =========================================================

  Future<bool> login() async {
    _setLoading();

    try {
      _user = await _repository.login(
        login: loginController.text.trim(),
        password: loginPasswordController.text,
      );

      _status = AuthStatus.authenticated;
      _errorMessage = null;

      clearLoginForm();

      notifyListeners();

      return true;
    } on AppException catch (error) {
      _setError(error.message);

      return false;
    }
  }

  // =========================================================
  // REGISTER
  // =========================================================

  Future<bool> register() async {
    if (!_termsAccepted) {
      _errorMessage =
          'Anda harus menyetujui Syarat & Ketentuan.';

      notifyListeners();

      return false;
    }

    _setLoading();

    try {
      _user = await _repository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: registerPasswordController.text,
        passwordConfirmation:
            confirmPasswordController.text,
      );

      _status = AuthStatus.authenticated;
      _errorMessage = null;

      clearRegisterForm();

      notifyListeners();

      return true;
    } on AppException catch (error) {
      _setError(error.message);

      return false;
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      _user = null;
      _errorMessage = null;
      _status = AuthStatus.unauthenticated;

      clearForms();

      notifyListeners();
    }
  }

  // =========================================================
  // PASSWORD VISIBILITY
  // =========================================================

  void toggleLoginPasswordVisibility() {
    _loginPasswordVisible = !_loginPasswordVisible;

    notifyListeners();
  }

  void toggleRegisterPasswordVisibility() {
    _registerPasswordVisible = !_registerPasswordVisible;

    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;

    notifyListeners();
  }

  // =========================================================
  // TERMS
  // =========================================================

  void setTermsAccepted(bool value) {
    _termsAccepted = value;

    notifyListeners();
  }

  // =========================================================
  // VALIDATION
  // =========================================================

  String? validateRequired(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi.';
    }

    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email wajib diisi.';
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(email)) {
      return 'Format email tidak valid.';
    }

    return null;
  }

  String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Nomor HP wajib diisi.';
    }

    final regex = RegExp(r'^[0-9+]+$');

    if (!regex.hasMatch(phone)) {
      return 'Format nomor HP tidak valid.';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi.';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter.';
    }

    return null;
  }

  String? validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi.';
    }

    if (value != registerPasswordController.text) {
      return 'Konfirmasi password tidak sama.';
    }

    return null;
  }

  // =========================================================
  // ERROR
  // =========================================================

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;

    notifyListeners();
  }

  void _setLoading() {
    _errorMessage = null;
    _status = AuthStatus.loading;

    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.unauthenticated;

    notifyListeners();
  }

  // =========================================================
  // CLEAR FORM
  // =========================================================

  void clearLoginForm() {
    loginController.clear();
    loginPasswordController.clear();

    _loginPasswordVisible = false;
  }

  void clearRegisterForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();

    registerPasswordController.clear();
    confirmPasswordController.clear();

    _registerPasswordVisible = false;
    _confirmPasswordVisible = false;

    _termsAccepted = false;
  }

  void clearForms() {
    clearLoginForm();
    clearRegisterForm();
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    loginController.dispose();
    loginPasswordController.dispose();

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    registerPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
}
