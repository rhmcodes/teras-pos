import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../router/app_routes.dart';
import '../../../shared/widgets/app_page.dart';
import '../widgets/settings_info_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(
      title: 'Settings',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.dashboardPath),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 56),
        children: const <Widget>[
          SettingsInfoCard(
            icon: Icons.storage_outlined,
            title: 'Backend Mode',
            subtitle: AppConfig.backendMode,
          ),
          SettingsInfoCard(
            icon: Icons.info_outline,
            title: 'Application Version',
            subtitle: AppConfig.appVersion,
          ),
          SettingsInfoCard(
            icon: Icons.cloud_outlined,
            title: 'Firebase Status',
            subtitle: AppConfig.firebaseStatus,
          ),
          SettingsInfoCard(
            icon: Icons.architecture_outlined,
            title: 'Architecture',
            subtitle: 'Clean Architecture + Repository Pattern + Riverpod',
          ),
        ],
      ),
    );
  }
}
