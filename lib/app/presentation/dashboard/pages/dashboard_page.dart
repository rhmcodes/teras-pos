import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../auth/providers/auth_provider.dart';
import '../../product/providers/product_provider.dart';
import '../../transaction/providers/transaction_provider.dart';
import '../../../router/app_routes.dart';
import '../../../shared/widgets/metric_card.dart';
import '../widgets/dashboard_header_card.dart';
import '../widgets/dashboard_menu_tile.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(productControllerProvider.notifier).loadProducts();
      await ref.read(transactionControllerProvider.notifier).loadTransactions();
    });
  }

  Future<void> _logout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (!mounted) {
      return;
    }

    context.go(AppRoutes.loginPath);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final productState = ref.watch(productControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);
    final revenue = transactionState.transactions.fold<double>(0, (total, item) => total + item.grandTotal);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.go(AppRoutes.settingsPath),
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 56),
          children: <Widget>[
            DashboardHeaderCard(name: auth.user?.name ?? 'Cashier'),
            const SizedBox(height: 14),
            MetricCard(
              title: 'Products',
              value: productState.products.length.toString(),
              icon: Icons.inventory_2_outlined,
            ),
            MetricCard(
              title: 'Transactions',
              value: transactionState.transactions.length.toString(),
              icon: Icons.receipt_long_outlined,
            ),
            MetricCard(
              title: 'Revenue',
              value: CurrencyFormatter.rupiah(revenue),
              icon: Icons.payments_outlined,
            ),
            const SizedBox(height: 20),
            Text('Menu', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            DashboardMenuTile(
              icon: Icons.inventory_2_outlined,
              title: 'Products',
              subtitle: 'List, add, edit, and delete products.',
              onTap: () => context.go(AppRoutes.productsPath),
            ),
            DashboardMenuTile(
              icon: Icons.add_shopping_cart,
              title: 'Create Transaction',
              subtitle: 'Create a simple POS transaction.',
              onTap: () => context.go(AppRoutes.transactionCreatePath),
            ),
            DashboardMenuTile(
              icon: Icons.receipt_long_outlined,
              title: 'Transactions',
              subtitle: 'List and view sales transaction details.',
              onTap: () => context.go(AppRoutes.transactionsPath),
            ),
            DashboardMenuTile(
              icon: Icons.analytics_outlined,
              title: 'Sales Report',
              subtitle: 'Summary, table view, and CSV export.',
              onTap: () => context.go(AppRoutes.reportPath),
            ),
          ],
        ),
      ),
    );
  }
}
