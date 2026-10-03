import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/core/error/app_exception.dart';
import 'package:smart_tani_mobile/core/widget/global_snackbar.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/auth_session_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    if (_isLoggingOut) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await context.read<AuthSessionProvider>().logout();
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }

      showGlobalSnackbar(
        context,
        title: 'Gagal',
        subtitle: error.message,
        mode: SnackBarMode.failure,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: FilledButton(
          onPressed: _isLoggingOut ? null : _handleLogout,
          child: Text(
            _isLoggingOut ? 'Memproses...' : 'Keluar',
          ),
        ),
      ),
    );
  }
}
