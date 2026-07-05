import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase extends BaseUseCase<Product?, String> {
  GetProductDetailUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<Product?>> call(String params) {
    return _repository.getProductById(params);
  }
}
