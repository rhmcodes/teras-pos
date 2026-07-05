import 'package:flutter_riverpod/legacy.dart';

import '../../../core/usecase/base_usecase.dart';
import '../../../domain/product/entities/product.dart';
import '../../../domain/location/usecases/get_current_location_usecase.dart';
import '../../../domain/transaction/entities/sales_transaction.dart';
import '../../../domain/transaction/entities/transaction_draft.dart';
import '../../../domain/transaction/entities/transaction_item.dart';
import '../../../domain/transaction/usecases/create_transaction_usecase.dart';
import '../../../domain/transaction/usecases/get_transaction_detail_usecase.dart';
import '../../../domain/transaction/usecases/get_transactions_usecase.dart';
import '../../../injection/app_providers.dart';
import '../states/cart_state.dart';
import '../states/transaction_state.dart';

final cartControllerProvider = StateNotifierProvider<CartController, CartState>((ref) {
  return CartController();
});

final transactionControllerProvider = StateNotifierProvider<TransactionController, TransactionState>((ref) {
  return TransactionController(
    ref.watch(getTransactionsUseCaseProvider),
    ref.watch(getTransactionDetailUseCaseProvider),
    ref.watch(createTransactionUseCaseProvider),
    ref.watch(getCurrentLocationUseCaseProvider),
  );
});

class CartController extends StateNotifier<CartState> {
  CartController() : super(const CartState());

  bool addProduct(Product product) {
    if (product.isOutOfStock) {
      return false;
    }

    final items = List<TransactionItem>.from(state.items);
    final index = items.indexWhere((item) => item.productId == product.id);

    if (index == -1) {
      items.add(
        TransactionItem(
          productId: product.id,
          productName: product.name,
          unitPrice: product.price,
          quantity: 1,
        ),
      );
    } else {
      final item = items[index];
      if (item.quantity >= product.stock) {
        return false;
      }

      items[index] = item.copyWith(quantity: item.quantity + 1);
    }

    state = state.copyWith(items: items);
    return true;
  }

  void decrease(String productId) {
    final items = List<TransactionItem>.from(state.items);
    final index = items.indexWhere((item) => item.productId == productId);

    if (index == -1) {
      return;
    }

    final item = items[index];
    if (item.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(quantity: item.quantity - 1);
    }

    state = state.copyWith(items: items);
  }

  void remove(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.productId != productId).toList(),
    );
  }

  void clear() {
    state = const CartState();
  }
}

class TransactionController extends StateNotifier<TransactionState> {
  TransactionController(
    this._getTransactionsUseCase,
    this._getTransactionDetailUseCase,
    this._createTransactionUseCase,
    this._getCurrentLocationUseCase,
  ) : super(const TransactionState());

  final GetTransactionsUseCase _getTransactionsUseCase;
  final GetTransactionDetailUseCase _getTransactionDetailUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getTransactionsUseCase(const NoParams());
    state = result.when(
      success: (transactions) => state.copyWith(
        transactions: transactions,
        isLoading: false,
        clearError: true,
      ),
      failure: (failure) => state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
    );
  }

  Future<SalesTransaction?> findTransaction(String id) async {
    final matchingTransactions = state.transactions.where((transaction) => transaction.id == id);
    final cached = matchingTransactions.isEmpty ? null : matchingTransactions.first;
    if (cached != null) {
      return cached;
    }

    final result = await _getTransactionDetailUseCase(id);
    return result.when(success: (transaction) => transaction, failure: (_) => null);
  }

  Future<bool> createTransaction({
    required List<TransactionItem> items,
    required String cashierName,
    required String paymentMethod,
    required double paidAmount,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearLastCreated: true);

    final locationResult = await _getCurrentLocationUseCase(const NoParams());
    final location = locationResult.when(
      success: (snapshot) => snapshot,
      failure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return null;
      },
    );

    if (location == null) {
      return false;
    }

    final draft = TransactionDraft(
      items: items,
      cashierName: cashierName,
      paymentMethod: paymentMethod,
      paidAmount: paidAmount,
      latitude: location.latitude,
      longitude: location.longitude,
      locationName: location.locationName,
    );

    final result = await _createTransactionUseCase(draft);
    return result.when(
      success: (transaction) async {
        await loadTransactions();
        state = state.copyWith(lastCreatedTransaction: transaction, clearError: true);
        return true;
      },
      failure: (failure) async {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }
}
