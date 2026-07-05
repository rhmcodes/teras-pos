import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                tooltip: 'Back',
                onPressed: onBackPressed ?? () {
                  Navigator.of(context).maybePop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              )
            : null,
        titleSpacing: showBackButton ? 0 : null,
        actions: actions,
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(color: AppColors.background),
          child: child,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
