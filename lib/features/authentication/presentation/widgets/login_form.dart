import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osc25/core/design_system/theme/colors.dart';
import 'package:osc25/features/authentication/presentation/controller/auth_controller.dart';
import 'package:osc25/l10n/l10n.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final l10n = context.l10n!;

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: l10n.labelTextEmail),
          onChanged: (val) => controller.email.value = val,
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: l10n.labelTextPassword),
          onChanged: (val) => controller.password.value = val,
        ),
        const SizedBox(height: 24),
        Obx(
          () => ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.primary),
            ),
            onPressed: controller.isLoading.value ? null : controller.login,
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    l10n.buttonTextLogin,
                    style: TextStyle(color: AppColors.accent),
                  ),
          ),
        ),
      ],
    );
  }
}
