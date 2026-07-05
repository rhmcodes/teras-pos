import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../../../router/app_routes.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/loading_widget.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => ref.read(productControllerProvider.notifier).loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);

    return AppPage(
      title: 'Products',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.dashboardPath),
      actions: <Widget>[
        IconButton(
          onPressed: () => ref.read(productControllerProvider.notifier).loadProducts(),
          icon: const Icon(Icons.refresh),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.productAddPath),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      child: Builder(
        builder: (context) {
          if (state.isLoading && state.products.isEmpty) {
            return const LoadingWidget();
          }

          if (state.errorMessage != null && state.products.isEmpty) {
            return AppErrorWidget(
              message: state.errorMessage!,
              onRetry: () => ref.read(productControllerProvider.notifier).loadProducts(),
            );
          }

          if (state.products.isEmpty) {
            return EmptyStateWidget(
              title: 'No products available',
              message: 'Add the first product to start creating transactions.',
              action: ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.productAddPath),
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 104),
            itemCount: state.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductCard(
                product: product,
                onEdit: () => context.go(AppRoutes.productEdit(product.id)),
                onDelete: () async {
                  final success = await ref.read(productControllerProvider.notifier).deleteProduct(product.id);
                  if (!context.mounted) {
                    return;
                  }

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product deleted successfully.')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
