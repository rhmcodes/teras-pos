import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase extends BaseUseCase<void, String> {
  DeleteProductUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.deleteProduct(params);
  }
}
