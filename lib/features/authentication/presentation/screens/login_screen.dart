import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osc25/features/authentication/data/datasources/remote/auth_data_source.dart';
import 'package:osc25/features/authentication/domain/auth_repository.dart';
import 'package:osc25/features/authentication/presentation/controller/auth_controller.dart';
import 'package:osc25/features/authentication/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(AuthRepository(AuthDataSource())));

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Padding(padding: EdgeInsets.all(16.0), child: LoginForm()),
    );
  }
}
