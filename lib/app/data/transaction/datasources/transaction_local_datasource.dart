import '../../local/local_pos_database.dart';
import '../models/sales_transaction_model.dart';
import '../../../domain/transaction/entities/transaction_draft.dart';

class TransactionLocalDataSource {
  TransactionLocalDataSource(this._database);

  final LocalPosDatabase _database;

  Future<List<SalesTransactionModel>> getTransactions() {
    return _database.getTransactions();
  }

  Future<SalesTransactionModel?> getTransactionById(String id) {
    return _database.getTransactionById(id);
  }

  Future<SalesTransactionModel> createTransaction(TransactionDraft draft) {
    return _database.createTransaction(draft);
  }
}
