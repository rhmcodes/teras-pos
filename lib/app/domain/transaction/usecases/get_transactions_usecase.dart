import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/sales_transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase extends BaseUseCase<List<SalesTransaction>, NoParams> {
  GetTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<List<SalesTransaction>>> call(NoParams params) {
    return _repository.getTransactions();
  }
}
