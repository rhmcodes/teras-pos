import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/sales_transaction.dart';
import '../entities/transaction_draft.dart';
import '../repositories/transaction_repository.dart';

class CreateTransactionUseCase extends BaseUseCase<SalesTransaction, TransactionDraft> {
  CreateTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<SalesTransaction>> call(TransactionDraft params) {
    return _repository.createTransaction(params);
  }
}
