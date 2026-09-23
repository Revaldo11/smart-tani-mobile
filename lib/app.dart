import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/app/routes/app_router.dart';


class SmartTaniApp extends StatelessWidget {
  const SmartTaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Smart Tani',
      routerConfig: appRouter,
    );
  }
}