import '../../../core/exceptions/error_handler.dart';
import '../../../core/result/result.dart';
import '../datasources/transaction_local_datasource.dart';
import '../../../domain/transaction/entities/sales_transaction.dart';
import '../../../domain/transaction/entities/transaction_draft.dart';
import '../../../domain/transaction/repositories/transaction_repository.dart';

class DummyTransactionRepository implements TransactionRepository {
  DummyTransactionRepository(this._localDataSource);

  final TransactionLocalDataSource _localDataSource;

  @override
  Future<Result<List<SalesTransaction>>> getTransactions() async {
    try {
      final transactions = await _localDataSource.getTransactions();
      return Success<List<SalesTransaction>>(transactions.map((item) => item.toEntity()).toList());
    } catch (error) {
      return Failed<List<SalesTransaction>>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<SalesTransaction?>> getTransactionById(String id) async {
    try {
      final transaction = await _localDataSource.getTransactionById(id);
      return Success<SalesTransaction?>(transaction?.toEntity());
    } catch (error) {
      return Failed<SalesTransaction?>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<SalesTransaction>> createTransaction(TransactionDraft draft) async {
    try {
      final transaction = await _localDataSource.createTransaction(draft);
      return Success<SalesTransaction>(transaction.toEntity());
    } catch (error) {
      return Failed<SalesTransaction>(ErrorHandler.fromException(error));
    }
  }
}
