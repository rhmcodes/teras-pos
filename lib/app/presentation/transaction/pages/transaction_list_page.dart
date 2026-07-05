import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';
import '../../../router/app_routes.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/loading_widget.dart';

class TransactionListPage extends ConsumerStatefulWidget {
  const TransactionListPage({super.key});

  @override
  ConsumerState<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends ConsumerState<TransactionListPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => ref.read(transactionControllerProvider.notifier).loadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionControllerProvider);

    return AppPage(
      title: 'Transactions',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.dashboardPath),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.transactionCreatePath),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('New Sale'),
      ),
      child: Builder(
        builder: (context) {
          if (state.isLoading && state.transactions.isEmpty) {
            return const LoadingWidget();
          }

          if (state.errorMessage != null && state.transactions.isEmpty) {
            return AppErrorWidget(
              message: state.errorMessage!,
              onRetry: () => ref.read(transactionControllerProvider.notifier).loadTransactions(),
            );
          }

          if (state.transactions.isEmpty) {
            return EmptyStateWidget(
              title: 'No transactions available',
              message: 'Create the first transaction from the New Sale menu.',
              action: ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.transactionCreatePath),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('New Sale'),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 104),
            itemCount: state.transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return TransactionCard(
                transaction: transaction,
                onTap: () => context.go(AppRoutes.transactionDetail(transaction.id)),
              );
            },
          );
        },
      ),
    );
  }
}
