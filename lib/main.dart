import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_tani_mobile/app.dart';
import 'package:smart_tani_mobile/app/routes/app_router.dart';
import 'package:smart_tani_mobile/core/storage/preference_service.dart';
import 'package:smart_tani_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:smart_tani_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/login_form_provider.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/register_form_provider.dart';

import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  const flutterSecureStorage = FlutterSecureStorage();

  final secureStorageService = SecureStorageService(
    flutterSecureStorage,
  );

  final preferenceService = PreferenceService(preferences);

  final dioClient = DioClient(
    secureStorage: secureStorageService,
  );

  final authRemoteDataSource = AuthRemoteDataSource(
    dioClient.dio,
  );

  final authRepository = AuthRepository(
    remoteDataSource: authRemoteDataSource,
    secureStorage: secureStorageService,
  );

  final authSessionProvider = AuthSessionProvider(
    authRepository,
  );
  final loginFormProvider = LoginFormProvider(
    authRepository,
    authSessionProvider,
  );
  final registerFormProvider = RegisterFormProvider(
    authRepository,
    authSessionProvider,
  );

  final router = createRouter(
    authSessionProvider: authSessionProvider,
    preferenceService: preferenceService,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<SecureStorageService>.value(
          value: secureStorageService,
        ),
        Provider<PreferenceService>.value(
          value: preferenceService,
        ),
        Provider<DioClient>.value(value: dioClient),
        Provider<AuthRepository>.value(
          value: authRepository,
        ),
        ChangeNotifierProvider<AuthSessionProvider>.value(
          value: authSessionProvider,
        ),
        ChangeNotifierProvider<LoginFormProvider>.value(
          value: loginFormProvider,
        ),
        ChangeNotifierProvider<RegisterFormProvider>.value(
          value: registerFormProvider,
        ),
      ],
      child: SmartTaniApp(router: router),
    ),
  );
}
