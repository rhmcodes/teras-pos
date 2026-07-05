import '../../../core/result/result.dart';
import '../entities/sales_transaction.dart';
import '../entities/transaction_draft.dart';

abstract class TransactionRepository {
  Future<Result<List<SalesTransaction>>> getTransactions();
  Future<Result<SalesTransaction?>> getTransactionById(String id);
  Future<Result<SalesTransaction>> createTransaction(TransactionDraft draft);
}
