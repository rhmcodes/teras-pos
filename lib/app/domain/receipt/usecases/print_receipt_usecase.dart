import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../repositories/receipt_repository.dart';
import '../../transaction/entities/sales_transaction.dart';

class PrintReceiptUseCase extends BaseUseCase<void, SalesTransaction> {
  PrintReceiptUseCase(this._repository);

  final ReceiptRepository _repository;

  @override
  Future<Result<void>> call(SalesTransaction params) {
    return _repository.printReceipt(params);
  }
}
