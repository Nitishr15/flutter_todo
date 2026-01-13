import 'package:flutter/material.dart';
import 'task_page.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/padding.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;

  void _login() {
    if (_userCtrl.text == 'admin' && _passCtrl.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TaskPage()),
      );
    } else {
      setState(() => _error = AppStrings.invalidCredentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.s16),
        child: Column(
          children: [
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: AppStrings.username),
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: AppStrings.password),
              obscureText: true,
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: AppPadding.s20),
            ElevatedButton(
              onPressed: _login,
              child: const Text(AppStrings.loginTitle),
            ),
          ],
        ),
      ),
    );
  }
}
