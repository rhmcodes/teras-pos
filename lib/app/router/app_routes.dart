class AppRoutes {
  const AppRoutes._();

  static const String splashPath = '/';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String forgotPasswordPath = '/forgot-password';
  static const String dashboardPath = '/dashboard';
  static const String productsPath = '/products';
  static const String productAddPath = '/products/new';
  static const String productEditPath = '/products/:id/edit';
  static const String transactionsPath = '/transactions';
  static const String transactionCreatePath = '/transactions/new';
  static const String transactionDetailPath = '/transactions/:id';
  static const String reportPath = '/report';
  static const String settingsPath = '/settings';

  static String productEdit(String id) => '/products/$id/edit';
  static String transactionDetail(String id) => '/transactions/$id';
}
