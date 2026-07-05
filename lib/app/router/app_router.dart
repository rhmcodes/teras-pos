import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/auth/pages/forgot_password_page.dart';
import '../presentation/auth/pages/login_page.dart';
import '../presentation/auth/pages/register_page.dart';
import '../presentation/dashboard/pages/dashboard_page.dart';
import '../presentation/product/pages/product_form_page.dart';
import '../presentation/product/pages/product_list_page.dart';
import '../presentation/report/pages/report_page.dart';
import '../presentation/settings/pages/settings_page.dart';
import '../presentation/splash/pages/splash_page.dart';
import '../presentation/transaction/pages/transaction_create_page.dart';
import '../presentation/transaction/pages/transaction_detail_page.dart';
import '../presentation/transaction/pages/transaction_list_page.dart';
import 'app_routes.dart';
import 'app_transition.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    routes: <RouteBase>[
      _route(AppRoutes.splashPath, const SplashPage()),
      _route(AppRoutes.loginPath, const LoginPage()),
      _route(AppRoutes.registerPath, const RegisterPage()),
      _route(AppRoutes.forgotPasswordPath, const ForgotPasswordPage()),
      _route(AppRoutes.dashboardPath, const DashboardPage()),
      _route(AppRoutes.productsPath, const ProductListPage()),
      _route(AppRoutes.productAddPath, const ProductFormPage()),
      GoRoute(
        path: AppRoutes.productEditPath,
        pageBuilder: (context, state) {
          return AppTransition.fade(
            state: state,
            child: ProductFormPage(productId: state.pathParameters['id']),
          );
        },
      ),
      _route(AppRoutes.transactionsPath, const TransactionListPage()),
      _route(AppRoutes.transactionCreatePath, const TransactionCreatePage()),
      GoRoute(
        path: AppRoutes.transactionDetailPath,
        pageBuilder: (context, state) {
          return AppTransition.fade(
            state: state,
            child: TransactionDetailPage(transactionId: state.pathParameters['id'] ?? ''),
          );
        },
      ),
      _route(AppRoutes.reportPath, const ReportPage()),
      _route(AppRoutes.settingsPath, const SettingsPage()),
    ],
    errorBuilder: (context, state) => const LoginPage(),
  );

  static GoRoute _route(String path, Widget child) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) {
        return AppTransition.fade(state: state, child: child);
      },
    );
  }
}
