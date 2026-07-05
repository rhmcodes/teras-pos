import '../../local/local_pos_database.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  ProductLocalDataSource(this._database);

  final LocalPosDatabase _database;

  Future<List<ProductModel>> getProducts() {
    return _database.getProducts();
  }

  Future<ProductModel?> getProductById(String id) {
    return _database.getProductById(id);
  }

  Future<ProductModel> addProduct(ProductModel product) {
    return _database.addProduct(product);
  }

  Future<ProductModel> updateProduct(ProductModel product) {
    return _database.updateProduct(product);
  }

  Future<void> deleteProduct(String id) {
    return _database.deleteProduct(id);
  }
}
