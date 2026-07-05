import '../../../core/exceptions/error_handler.dart';
import '../../../core/result/result.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';
import '../../../domain/product/entities/product.dart';
import '../../../domain/product/repositories/product_repository.dart';

class DummyProductRepository implements ProductRepository {
  DummyProductRepository(this._localDataSource);

  final ProductLocalDataSource _localDataSource;

  @override
  Future<Result<List<Product>>> getProducts() async {
    try {
      final products = await _localDataSource.getProducts();
      return Success<List<Product>>(products.map((item) => item.toEntity()).toList());
    } catch (error) {
      return Failed<List<Product>>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<Product?>> getProductById(String id) async {
    try {
      final product = await _localDataSource.getProductById(id);
      return Success<Product?>(product?.toEntity());
    } catch (error) {
      return Failed<Product?>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<Product>> addProduct(Product product) async {
    try {
      final saved = await _localDataSource.addProduct(ProductModel.fromEntity(product));
      return Success<Product>(saved.toEntity());
    } catch (error) {
      return Failed<Product>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<Product>> updateProduct(Product product) async {
    try {
      final saved = await _localDataSource.updateProduct(ProductModel.fromEntity(product));
      return Success<Product>(saved.toEntity());
    } catch (error) {
      return Failed<Product>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    try {
      await _localDataSource.deleteProduct(id);
      return const Success<void>(null);
    } catch (error) {
      return Failed<void>(ErrorHandler.fromException(error));
    }
  }
}
