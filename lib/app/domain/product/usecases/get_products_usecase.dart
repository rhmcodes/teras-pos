import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase extends BaseUseCase<List<Product>, NoParams> {
  GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<List<Product>>> call(NoParams params) {
    return _repository.getProducts();
  }
}
