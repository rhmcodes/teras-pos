import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SaveProductUseCase extends BaseUseCase<Product, SaveProductParams> {
  SaveProductUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Result<Product>> call(SaveProductParams params) {
    if (params.isEditing) {
      return _repository.updateProduct(params.product);
    }

    return _repository.addProduct(params.product);
  }
}

class SaveProductParams {
  const SaveProductParams({
    required this.product,
    required this.isEditing,
  });

  final Product product;
  final bool isEditing;
}
