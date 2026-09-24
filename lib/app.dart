import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_tani_mobile/core/theme/app_theme.dart';


class SmartTaniApp extends StatelessWidget {
  const SmartTaniApp({
    required this.router,
    super.key,
  });

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Tani',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}