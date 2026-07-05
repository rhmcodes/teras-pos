import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';

class SplashBrand extends StatelessWidget {
  const SplashBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppShadow.soft,
          ),
          child: const Icon(Icons.point_of_sale_rounded, size: 42, color: Colors.white),
        ),
        const SizedBox(height: 18),
        const Text(
          AppConfig.appName,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        const Text('Clean Architecture POS', style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }
}
