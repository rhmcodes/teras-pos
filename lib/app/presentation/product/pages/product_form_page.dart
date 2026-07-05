import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/id_generator.dart';
import '../../../domain/product/entities/product.dart';
import '../providers/product_provider.dart';
import '../../../router/app_routes.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../theme/app_colors.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({super.key, this.productId});

  final String? productId;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  Product? _editingProduct;
  bool _isInitializing = false;

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    setState(() => _isInitializing = true);
    final product = await ref.read(productControllerProvider.notifier).findProduct(widget.productId!);
    if (!mounted) {
      return;
    }

    if (product != null) {
      _editingProduct = product;
      _nameController.text = product.name;
      _skuController.text = product.sku;
      _categoryController.text = product.category;
      _priceController.text = product.price.toStringAsFixed(0);
      _stockController.text = product.stock.toString();
    }

    setState(() => _isInitializing = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }


  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }

    return null;
  }

  String? _priceValidator(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Price must be greater than 0.';
    }

    return null;
  }

  String? _stockValidator(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null || parsed < 0) {
      return 'Stock cannot be negative.';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final product = Product(
      id: _editingProduct?.id ?? IdGenerator.create('prd'),
      name: _nameController.text.trim(),
      sku: _skuController.text.trim().toUpperCase(),
      category: _categoryController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      createdAt: _editingProduct?.createdAt ?? now,
      updatedAt: now,
    );

    final success = await ref.read(productControllerProvider.notifier).saveProduct(
          product,
          isEditing: _isEditing,
        );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Product updated successfully.' : 'Product added successfully.')),
      );
      context.go(AppRoutes.productsPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);

    return AppPage(
      title: _isEditing ? 'Edit Product' : 'Add Product',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.productsPath),
      child: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 56),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    AppTextField(
                      controller: _nameController,
                      label: 'Product Name',
                      validator: (value) => _requiredValidator(value, 'Product name'),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _skuController,
                      label: 'SKU',
                      validator: (value) => _requiredValidator(value, 'SKU'),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _categoryController,
                      label: 'Category',
                      validator: (value) => _requiredValidator(value, 'Category'),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _priceController,
                      label: 'Price',
                      keyboardType: TextInputType.number,
                      validator: _priceValidator,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _stockController,
                      label: 'Stock',
                      keyboardType: TextInputType.number,
                      validator: _stockValidator,
                    ),
                    const SizedBox(height: 18),
                    if (state.errorMessage != null) ...<Widget>[
                      Text(state.errorMessage!, style: const TextStyle(color: AppColors.danger)),
                      const SizedBox(height: 14),
                    ],
                    PrimaryButton(
                      label: _isEditing ? 'Update Product' : 'Save Product',
                      icon: Icons.save_outlined,
                      isLoading: state.isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
