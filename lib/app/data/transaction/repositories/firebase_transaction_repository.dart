import '../../../core/failures/failure.dart';
import '../../../core/result/result.dart';
import '../../../domain/transaction/entities/sales_transaction.dart';
import '../../../domain/transaction/entities/transaction_draft.dart';
import '../../../domain/transaction/repositories/transaction_repository.dart';

/// Firebase-ready extension point for Firestore transactions collection.
class FirebaseTransactionRepository implements TransactionRepository {
  const FirebaseTransactionRepository();

  Failure get _notConfigured => const Failure(
        message: 'Firebase Firestore is not configured. Use DummyTransactionRepository for technical test mode.',
        code: 'firebase-not-configured',
      );

  @override
  Future<Result<List<SalesTransaction>>> getTransactions() async {
    return Failed<List<SalesTransaction>>(_notConfigured);
  }

  @override
  Future<Result<SalesTransaction?>> getTransactionById(String id) async {
    return Failed<SalesTransaction?>(_notConfigured);
  }

  @override
  Future<Result<SalesTransaction>> createTransaction(TransactionDraft draft) async {
    return Failed<SalesTransaction>(_notConfigured);
  }
}
