import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/auth_session_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _splashDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(_splashDelay);

      if (!mounted) {
        return;
      }

      context
          .read<AuthSessionProvider>()
          .initializeSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
              'assets/images/splash/splash_bg.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 220,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Image.asset(
                        'assets/images/smart_tani_1.png',
                        filterQuality: FilterQuality.high,
                        width: 250,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 30,
                      top: 400,
                    ),
                    child: Text(
                      'Pertanian yang lebih cerdas\nuntuk masa depan yang lebih baik',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
