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

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!mounted) {
      return;
    }

    if (success) {
      context.go(AppRoutes.dashboardPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return AppPage(
      title: 'Register',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.loginPath),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 44),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const AuthBrandHeader(
                title: 'Create Account',
                subtitle: 'Register a dummy/local account for testing the POS workflow.',
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) => value == null || value.isEmpty ? 'Name is required.' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Email is required.' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters.' : null,
              ),
              const SizedBox(height: 16),
              if (state.errorMessage != null) ...<Widget>[
                Text(state.errorMessage!, style: const TextStyle(color: AppColors.danger)),
                const SizedBox(height: 14),
              ],
              PrimaryButton(
                label: 'Create Account',
                icon: Icons.person_add_alt,
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => context.go(AppRoutes.loginPath),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
