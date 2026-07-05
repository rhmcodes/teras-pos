import '../../../domain/transaction/entities/sales_transaction.dart';

class TransactionState {
  const TransactionState({
    this.transactions = const <SalesTransaction>[],
    this.isLoading = false,
    this.errorMessage,
    this.lastCreatedTransaction,
  });

  final List<SalesTransaction> transactions;
  final bool isLoading;
  final String? errorMessage;
  final SalesTransaction? lastCreatedTransaction;

  TransactionState copyWith({
    List<SalesTransaction>? transactions,
    bool? isLoading,
    String? errorMessage,
    SalesTransaction? lastCreatedTransaction,
    bool clearError = false,
    bool clearLastCreated = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      lastCreatedTransaction: clearLastCreated ? null : lastCreatedTransaction ?? this.lastCreatedTransaction,
    );
  }
}
