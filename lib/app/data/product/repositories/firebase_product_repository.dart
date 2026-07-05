import '../../../core/failures/failure.dart';
import '../../../core/result/result.dart';
import '../../../domain/product/entities/product.dart';
import '../../../domain/product/repositories/product_repository.dart';

/// Firebase-ready extension point for Firestore product collection.
class FirebaseProductRepository implements ProductRepository {
  const FirebaseProductRepository();

  Failure get _notConfigured => const Failure(
        message: 'Firebase Firestore is not configured. Use DummyProductRepository for technical test mode.',
        code: 'firebase-not-configured',
      );

  @override
  Future<Result<List<Product>>> getProducts() async {
    return Failed<List<Product>>(_notConfigured);
  }

  @override
  Future<Result<Product?>> getProductById(String id) async {
    return Failed<Product?>(_notConfigured);
  }

  @override
  Future<Result<Product>> addProduct(Product product) async {
    return Failed<Product>(_notConfigured);
  }

  @override
  Future<Result<Product>> updateProduct(Product product) async {
    return Failed<Product>(_notConfigured);
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    return Failed<void>(_notConfigured);
  }
}
