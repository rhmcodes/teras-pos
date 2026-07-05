import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../repositories/receipt_repository.dart';
import '../../transaction/entities/sales_transaction.dart';

class BuildReceiptTextUseCase extends BaseUseCase<String, SalesTransaction> {
  BuildReceiptTextUseCase(this._repository);

  final ReceiptRepository _repository;

  @override
  Future<Result<String>> call(SalesTransaction params) {
    return _repository.buildReceiptText(params);
  }
}
