import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../domain/product/entities/product.dart';
import '../../auth/providers/auth_provider.dart';
import '../../product/providers/product_provider.dart';
import '../providers/transaction_provider.dart';
import '../../../router/app_routes.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../theme/app_colors.dart';

class TransactionCreatePage extends ConsumerStatefulWidget {
  const TransactionCreatePage({super.key});

  @override
  ConsumerState<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends ConsumerState<TransactionCreatePage> {
  final _paidController = TextEditingController();
  String _paymentMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => ref.read(productControllerProvider.notifier).loadProducts());
  }

  @override
  void dispose() {
    _paidController.dispose();
    super.dispose();
  }

  Future<void> _checkout() async {
    final cart = ref.read(cartControllerProvider);
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The cart is still empty.')),
      );
      return;
    }

    final auth = ref.read(authControllerProvider);
    final paidAmount = double.tryParse(_paidController.text) ?? cart.subtotal;

    final success = await ref.read(transactionControllerProvider.notifier).createTransaction(
          items: cart.items,
          cashierName: auth.user?.name ?? 'Cashier Demo',
          paymentMethod: _paymentMethod,
          paidAmount: paidAmount,
        );

    if (!mounted) {
      return;
    }

    if (success) {
      final transaction = ref.read(transactionControllerProvider).lastCreatedTransaction;
      ref.read(cartControllerProvider.notifier).clear();
      await ref.read(productControllerProvider.notifier).loadProducts();

      if (!mounted) {
        return;
      }

      if (transaction != null) {
        context.go(AppRoutes.transactionDetail(transaction.id));
      } else {
        context.go(AppRoutes.transactionsPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productControllerProvider);
    final cart = ref.watch(cartControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);

    return AppPage(
      title: 'Create Transaction',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.transactionsPath),
      child: productState.isLoading && productState.products.isEmpty
          ? const LoadingWidget()
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 820;
                final productList = _ProductPicker(products: productState.products);
                final cartPanel = _CartPanel(
                  paymentMethod: _paymentMethod,
                  paidController: _paidController,
                  isLoading: transactionState.isLoading,
                  errorMessage: transactionState.errorMessage,
                  products: productState.products,
                  onPaymentChanged: (value) => setState(() => _paymentMethod = value),
                  onCheckout: _checkout,
                );

                if (productState.products.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No active products available',
                    message: 'Add products first before creating a transaction.',
                  );
                }

                if (isWide) {
                  return Row(
                    children: <Widget>[
                      Expanded(flex: 3, child: productList),
                      const VerticalDivider(width: 1),
                      Expanded(flex: 2, child: cartPanel),
                    ],
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 104),
                  children: <Widget>[
                    SizedBox(height: 420, child: productList),
                    const SizedBox(height: 12),
                    Text('Cart Total: ${CurrencyFormatter.rupiah(cart.subtotal)}'),
                    const SizedBox(height: 12),
                    SizedBox(height: 440, child: cartPanel),
                  ],
                );
              },
            ),
    );
  }
}

class _ProductPicker extends ConsumerWidget {
  const _ProductPicker({required this.products});

  final List<Product> products;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = products[index];
        final isOutOfStock = product.stock <= 0;

        return Card(
          child: ListTile(
            title: Text(product.name),
            subtitle: Text('${product.category} • Stock ${product.stock}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  CurrencyFormatter.rupiah(product.price),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextButton.icon(
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          final added = ref.read(cartControllerProvider.notifier).addProduct(product);
                          if (!added) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Insufficient stock for ${product.name}.')),
                            );
                          }
                        },
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(isOutOfStock ? 'Out' : 'Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CartPanel extends ConsumerWidget {
  const _CartPanel({
    required this.paymentMethod,
    required this.paidController,
    required this.isLoading,
    required this.products,
    required this.onPaymentChanged,
    required this.onCheckout,
    this.errorMessage,
  });

  final String paymentMethod;
  final TextEditingController paidController;
  final bool isLoading;
  final List<Product> products;
  final String? errorMessage;
  final ValueChanged<String> onPaymentChanged;
  final VoidCallback onCheckout;


  Product? _findProduct(String productId) {
    for (final product in products) {
      if (product.id == productId) {
        return product;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 56),
      children: <Widget>[
        Text('Cart', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (cart.items.isEmpty)
          const EmptyStateWidget(
            title: 'Empty Cart',
            message: 'Select products from the list to create a transaction.',
          )
        else
          ...cart.items.map(
            (item) {
              final product = _findProduct(item.productId);
              final hasReachedStock = product == null || item.quantity >= product.stock;

              return Card(
                child: ListTile(
                  title: Text(item.productName),
                  subtitle: Text('${item.quantity} x ${CurrencyFormatter.rupiah(item.unitPrice)}'),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(CurrencyFormatter.rupiah(item.total)),
                      IconButton(
                        onPressed: () => ref.read(cartControllerProvider.notifier).decrease(item.productId),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      IconButton(
                        onPressed: hasReachedStock
                            ? null
                            : () {
                                final added = ref.read(cartControllerProvider.notifier).addProduct(product!);
                                if (!added) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Insufficient stock for ${item.productName}.')),
                                  );
                                }
                              },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SummaryRow(label: 'Items', value: cart.totalQuantity.toString()),
                _SummaryRow(label: 'Subtotal', value: CurrencyFormatter.rupiah(cart.subtotal)),
                const Divider(),
                Text('Payment Method', style: Theme.of(context).textTheme.labelLarge),
                DropdownButton<String>(
                  value: paymentMethod,
                  isExpanded: true,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem<String>(value: 'QRIS', child: Text('QRIS')),
                    DropdownMenuItem<String>(value: 'Debit Card', child: Text('Debit Card')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onPaymentChanged(value);
                    }
                  },
                ),
                TextFormField(
                  controller: paidController,
                  decoration: InputDecoration(
                    labelText: 'Paid Amount',
                    hintText: cart.subtotal.toStringAsFixed(0),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 12),
                if (errorMessage != null) ...<Widget>[
                  Text(errorMessage!, style: const TextStyle(color: AppColors.danger)),
                  const SizedBox(height: 12),
                ],
                PrimaryButton(
                  label: 'Checkout',
                  icon: Icons.payments_outlined,
                  isLoading: isLoading,
                  onPressed: cart.isEmpty ? null : onCheckout,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
