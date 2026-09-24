import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tani_mobile/core/constant/const.dart';
import 'package:smart_tani_mobile/features/auth/presentation/providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: auth.loginController,
              validator: (value) => auth.validateRequired(
                value,
                'Email atau nomor HP',
              ),
            ),

            TextFormField(
              controller: auth.loginPasswordController,
              obscureText: !auth.loginPasswordVisible,
              validator: (value) => auth.validateRequired(
                value,
                'Password',
              ),
              // suffixIcon: IconButton(
              //   onPressed: auth.toggleLoginPassword,
              //   icon: Icon(
              //     auth.loginPasswordVisible
              //         ? Icons.visibility_off
              //         : Icons.visibility,
              //   ),
              // ),
            ),

            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      await context
                          .read<AuthProvider>()
                          .login();
                    },
              child: auth.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}