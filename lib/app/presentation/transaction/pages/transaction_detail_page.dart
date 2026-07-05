import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/transaction/entities/sales_transaction.dart';
import '../../../injection/app_providers.dart';
import '../providers/transaction_provider.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../router/app_routes.dart';

class TransactionDetailPage extends ConsumerStatefulWidget {
  const TransactionDetailPage({
    super.key,
    required this.transactionId,
  });

  final String transactionId;

  @override
  ConsumerState<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends ConsumerState<TransactionDetailPage> {
  SalesTransaction? _transaction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final transaction = await ref.read(transactionControllerProvider.notifier).findTransaction(widget.transactionId);
    if (!mounted) {
      return;
    }

    setState(() {
      _transaction = transaction;
      _isLoading = false;
    });
  }

  Future<void> _printReceipt() async {
    final transaction = _transaction;
    if (transaction == null) {
      return;
    }

    final result = await ref.read(buildReceiptTextUseCaseProvider)(transaction);
    final receipt = result.when(
      success: (text) => text,
      failure: (failure) => failure.message,
    );

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Receipt Preview'),
          content: SingleChildScrollView(
            child: SelectableText(
              receipt,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = _transaction;

    return AppPage(
      title: 'Transaction Detail',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.transactionsPath),
      actions: <Widget>[
        IconButton(
          onPressed: transaction == null ? null : _printReceipt,
          icon: const Icon(Icons.print_outlined),
        ),
      ],
      child: _isLoading
          ? const LoadingWidget()
          : transaction == null
              ? const EmptyStateWidget(title: 'Transaction not found')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 56),
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(transaction.invoiceNumber, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 6),
                            Text(DateFormatter.full(transaction.createdAt)),
                            Text('Cashier: ${transaction.cashierName}'),
                            Text('Location: ${transaction.locationName}'),
                            Text('GPS: ${transaction.latitude}, ${transaction.longitude}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...transaction.items.map(
                      (item) => Card(
                        child: ListTile(
                          title: Text(item.productName),
                          subtitle: Text('${item.quantity} x ${CurrencyFormatter.rupiah(item.unitPrice)}'),
                          trailing: Text(CurrencyFormatter.rupiah(item.total)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            _AmountRow(label: 'Subtotal', value: transaction.subtotal),
                            _AmountRow(label: 'Discount', value: transaction.discount),
                            _AmountRow(label: 'Tax', value: transaction.tax),
                            const Divider(),
                            _AmountRow(label: 'Grand Total', value: transaction.grandTotal, isBold: true),
                            _AmountRow(label: 'Paid', value: transaction.paidAmount),
                            _AmountRow(label: 'Change', value: transaction.changeAmount),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final double value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final style = isBold ? const TextStyle(fontWeight: FontWeight.w800) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: style)),
          Text(CurrencyFormatter.rupiah(value), style: style),
        ],
      ),
    );
  }
}
