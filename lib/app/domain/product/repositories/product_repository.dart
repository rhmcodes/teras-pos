import '../../../core/result/result.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts();
  Future<Result<Product?>> getProductById(String id);
  Future<Result<Product>> addProduct(Product product);
  Future<Result<Product>> updateProduct(Product product);
  Future<Result<void>> deleteProduct(String id);
}
