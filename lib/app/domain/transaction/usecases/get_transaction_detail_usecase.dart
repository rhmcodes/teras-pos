import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/sales_transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionDetailUseCase extends BaseUseCase<SalesTransaction?, String> {
  GetTransactionDetailUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<SalesTransaction?>> call(String params) {
    return _repository.getTransactionById(params);
  }
}
