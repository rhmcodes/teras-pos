import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../../router/app_routes.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../theme/app_colors.dart';
import '../widgets/auth_brand_header.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).forgotPassword(
          email: _emailController.text,
        );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset has been simulated successfully.')),
      );
      context.go(AppRoutes.loginPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return AppPage(
      title: 'Forgot Password',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.loginPath),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 44),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const AuthBrandHeader(
                title: 'Reset Password',
                subtitle: 'Enter your account email. In dummy/local mode, the reset process is simulated.',
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Email is required.' : null,
              ),
              const SizedBox(height: 18),
              if (state.errorMessage != null) ...<Widget>[
                Text(state.errorMessage!, style: const TextStyle(color: AppColors.danger)),
                const SizedBox(height: 12),
              ],
              PrimaryButton(
                label: 'Reset Password',
                icon: Icons.lock_reset,
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
