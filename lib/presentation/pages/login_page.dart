import 'package:flutter/material.dart';
import 'task_page.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/padding.dart';
import '../../core/constants/sizing.dart';
import '../../core/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;
  final _auth = AuthService();

  Future<void> _login() async {
    final navigator = Navigator.of(context);

    if (_userCtrl.text == 'admin' && _passCtrl.text == '1234') {
      await _auth.login();

      if (!mounted) return;

      navigator.pushReplacement(MaterialPageRoute(builder: (_) => TaskPage()));
    } else {
      if (!mounted) return;
      setState(() => _error = AppStrings.invalidCredentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                AppStrings.signIn,
                style: TextStyle(
                  fontSize: AppSizing.s42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _userCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.username,
                ),
              ),
              const SizedBox(height: AppSizing.s16),
              TextField(
                controller: _passCtrl,
                decoration: const InputDecoration(
                  labelText: AppStrings.password,
                ),
                obscureText: true,
              ),
              const SizedBox(height: AppSizing.s16),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppPadding.p08),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _login,
                child: const Text(AppStrings.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
