import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_tani_mobile/app.dart';
import 'package:smart_tani_mobile/core/storage/preference_service.dart';

import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  const flutterSecureStorage = FlutterSecureStorage();

  final secureStorageService = SecureStorageService(
    flutterSecureStorage,
  );

  final preferenceService = PreferenceService(
    preferences,
  );

  final dioClient = DioClient(
    secureStorage: secureStorageService,
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
        Provider<DioClient>.value(
          value: dioClient,
        ),
      ],
      child: const SmartTaniApp(),
    ),
  );
}