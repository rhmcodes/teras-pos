import '../../config/app_constants.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/utils/id_generator.dart';
import '../auth/models/app_user_model.dart';
import '../product/models/product_model.dart';
import '../transaction/models/sales_transaction_model.dart';
import '../transaction/models/transaction_item_model.dart';
import '../../domain/transaction/entities/transaction_draft.dart';

T? _firstOrNull<T>(Iterable<T> items) => items.isEmpty ? null : items.first;

class LocalPosDatabase {
  LocalPosDatabase() {
    _seed();
  }

  final List<AppUserModel> _users = <AppUserModel>[];
  final List<ProductModel> _products = <ProductModel>[];
  final List<SalesTransactionModel> _transactions = <SalesTransactionModel>[];

  String? _currentUserId;
  bool _seeded = false;

  Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 180));

  void _seed() {
    if (_seeded) {
      return;
    }

    final now = DateTime.now();

    _users.add(
      const AppUserModel(
        id: 'user-admin',
        name: 'Admin POS',
        email: AppConstants.demoEmail,
        role: 'Cashier Admin',
        password: AppConstants.demoPassword,
      ),
    );

    _products.addAll(<ProductModel>[
      ProductModel(
        id: 'prd-001',
        name: 'Brown Sugar Milk Coffee',
        sku: 'BEV-001',
        category: 'Beverage',
        price: 22000,
        stock: 35,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
      ),
      ProductModel(
        id: 'prd-002',
        name: 'Matcha Latte',
        sku: 'BEV-002',
        category: 'Beverage',
        price: 28000,
        stock: 24,
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now,
      ),
      ProductModel(
        id: 'prd-003',
        name: 'Croissant Butter',
        sku: 'FNB-001',
        category: 'Food',
        price: 25000,
        stock: 18,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      ProductModel(
        id: 'prd-004',
        name: 'Chicken Rice Bowl',
        sku: 'FNB-002',
        category: 'Food',
        price: 38000,
        stock: 15,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now,
      ),
      ProductModel(
        id: 'prd-005',
        name: 'Mineral Water 600ml',
        sku: 'BEV-003',
        category: 'Beverage',
        price: 8000,
        stock: 60,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
      ),
    ]);

    _transactions.addAll(_buildInitialTransactions(now));
    _seeded = true;
  }

  List<SalesTransactionModel> _buildInitialTransactions(DateTime now) {
    final firstItems = <TransactionItemModel>[
      const TransactionItemModel(
        productId: 'prd-001',
        productName: 'Brown Sugar Milk Coffee',
        unitPrice: 22000,
        quantity: 2,
      ),
      const TransactionItemModel(
        productId: 'prd-003',
        productName: 'Croissant Butter',
        unitPrice: 25000,
        quantity: 1,
      ),
    ];
    final firstSubtotal = firstItems.fold<double>(0, (total, item) => total + (item.unitPrice * item.quantity));

    final secondItems = <TransactionItemModel>[
      const TransactionItemModel(
        productId: 'prd-004',
        productName: 'Chicken Rice Bowl',
        unitPrice: 38000,
        quantity: 1,
      ),
      const TransactionItemModel(
        productId: 'prd-005',
        productName: 'Mineral Water 600ml',
        unitPrice: 8000,
        quantity: 2,
      ),
    ];
    final secondSubtotal = secondItems.fold<double>(0, (total, item) => total + (item.unitPrice * item.quantity));

    return <SalesTransactionModel>[
      SalesTransactionModel(
        id: 'trx-001',
        invoiceNumber: 'INV-${now.year}${now.month.toString().padLeft(2, '0')}0001',
        cashierName: 'Admin POS',
        items: firstItems,
        subtotal: firstSubtotal,
        discount: 0,
        tax: 0,
        grandTotal: firstSubtotal,
        paymentMethod: 'Cash',
        paidAmount: 100000,
        changeAmount: 100000 - firstSubtotal,
        latitude: -6.200000,
        longitude: 106.816666,
        locationName: 'Jakarta Store Demo',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      SalesTransactionModel(
        id: 'trx-002',
        invoiceNumber: 'INV-${now.year}${now.month.toString().padLeft(2, '0')}0002',
        cashierName: 'Admin POS',
        items: secondItems,
        subtotal: secondSubtotal,
        discount: 0,
        tax: 0,
        grandTotal: secondSubtotal,
        paymentMethod: 'QRIS',
        paidAmount: secondSubtotal,
        changeAmount: 0,
        latitude: -6.200000,
        longitude: 106.816666,
        locationName: 'Jakarta Store Demo',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }

  Future<AppUserModel> login(String email, String password) async {
    await _delay();
    final normalizedEmail = email.trim().toLowerCase();

    final user = _firstOrNull(_users.where((item) => item.email.toLowerCase() == normalizedEmail));
    if (user == null || user.password != password) {
      throw const ValidationException('Invalid email or password.');
    }

    _currentUserId = user.id;
    return user;
  }

  Future<AppUserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _delay();
    final normalizedEmail = email.trim().toLowerCase();
    final exists = _users.any((item) => item.email.toLowerCase() == normalizedEmail);

    if (exists) {
      throw const ValidationException('Email is already registered.');
    }

    final user = AppUserModel(
      id: IdGenerator.create('user'),
      name: name.trim(),
      email: normalizedEmail,
      role: 'Cashier',
      password: password,
    );

    _users.add(user);
    _currentUserId = user.id;
    return user;
  }

  Future<void> forgotPassword(String email) async {
    await _delay();
    final exists = _users.any((item) => item.email.toLowerCase() == email.trim().toLowerCase());
    if (!exists) {
      throw const ValidationException('Email was not found.');
    }
  }

  Future<void> logout() async {
    await _delay();
    _currentUserId = null;
  }

  Future<AppUserModel?> getCurrentUser() async {
    await _delay();
    if (_currentUserId == null) {
      return null;
    }

    return _firstOrNull(_users.where((item) => item.id == _currentUserId));
  }

  Future<List<ProductModel>> getProducts() async {
    await _delay();
    return List<ProductModel>.unmodifiable(_products.where((item) => item.isActive));
  }

  Future<ProductModel?> getProductById(String id) async {
    await _delay();
    return _firstOrNull(_products.where((item) => item.id == id && item.isActive));
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    await _delay();
    final skuExists = _products.any((item) => item.sku.toLowerCase() == product.sku.toLowerCase() && item.isActive);

    if (skuExists) {
      throw const ValidationException('SKU is already used by another product.');
    }

    _products.add(product);
    return product;
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    await _delay();
    final index = _products.indexWhere((item) => item.id == product.id);

    if (index == -1) {
      throw const ValidationException('Product not found.');
    }

    final skuExists = _products.any(
      (item) =>
          item.id != product.id &&
          item.sku.toLowerCase() == product.sku.toLowerCase() &&
          item.isActive,
    );

    if (skuExists) {
      throw const ValidationException('SKU is already used by another product.');
    }

    _products[index] = product;
    return product;
  }

  Future<void> deleteProduct(String id) async {
    await _delay();
    final index = _products.indexWhere((item) => item.id == id);

    if (index == -1) {
      throw const ValidationException('Product not found.');
    }

    _products[index] = _products[index].copyWith(
      isActive: false,
      updatedAt: DateTime.now(),
    );
  }

  Future<List<SalesTransactionModel>> getTransactions() async {
    await _delay();
    final sorted = List<SalesTransactionModel>.from(_transactions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List<SalesTransactionModel>.unmodifiable(sorted);
  }

  Future<SalesTransactionModel?> getTransactionById(String id) async {
    await _delay();
    return _firstOrNull(_transactions.where((item) => item.id == id));
  }

  Future<SalesTransactionModel> createTransaction(TransactionDraft draft) async {
    await _delay();

    if (draft.items.isEmpty) {
      throw const ValidationException('Transaction cart is still empty.');
    }

    for (final item in draft.items) {
      final productIndex = _products.indexWhere((product) => product.id == item.productId && product.isActive);
      if (productIndex == -1) {
        throw ValidationException('Product ${item.productName} was not found.');
      }

      final product = _products[productIndex];
      if (product.stock < item.quantity) {
        throw ValidationException('Insufficient stock for ${product.name}.');
      }
    }

    final subtotal = draft.items.fold<double>(0, (total, item) => total + item.total);
    final grandTotal = subtotal - draft.discount + draft.tax;

    if (draft.paidAmount < grandTotal) {
      throw const ValidationException('Paid amount is less than the total purchase amount.');
    }

    for (final item in draft.items) {
      final productIndex = _products.indexWhere((product) => product.id == item.productId && product.isActive);
      final product = _products[productIndex];
      _products[productIndex] = product.copyWith(
        stock: product.stock - item.quantity,
        updatedAt: DateTime.now(),
      );
    }

    final createdAt = DateTime.now();
    final invoiceSequence = (_transactions.length + 1).toString().padLeft(4, '0');
    final invoicePeriod = '${createdAt.year}${createdAt.month.toString().padLeft(2, '0')}';

    final transaction = SalesTransactionModel(
      id: IdGenerator.create('trx'),
      invoiceNumber: 'INV-$invoicePeriod$invoiceSequence',
      cashierName: draft.cashierName,
      items: draft.items.map(TransactionItemModel.fromEntity).toList(),
      subtotal: subtotal,
      discount: draft.discount,
      tax: draft.tax,
      grandTotal: grandTotal,
      paymentMethod: draft.paymentMethod,
      paidAmount: draft.paidAmount,
      changeAmount: draft.paidAmount - grandTotal,
      latitude: draft.latitude,
      longitude: draft.longitude,
      locationName: draft.locationName,
      createdAt: createdAt,
    );

    _transactions.add(transaction);
    return transaction;
  }
}
