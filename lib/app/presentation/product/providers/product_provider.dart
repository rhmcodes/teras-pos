import 'package:flutter_riverpod/legacy.dart';
import '../../../core/usecase/base_usecase.dart';
import '../../../domain/product/entities/product.dart';
import '../../../domain/product/usecases/delete_product_usecase.dart';
import '../../../domain/product/usecases/get_product_detail_usecase.dart';
import '../../../domain/product/usecases/get_products_usecase.dart';
import '../../../domain/product/usecases/save_product_usecase.dart';
import '../../../injection/app_providers.dart';
import '../states/product_state.dart';

final productControllerProvider = StateNotifierProvider<ProductController, ProductState>((ref) {
  return ProductController(
    ref.watch(getProductsUseCaseProvider),
    ref.watch(getProductDetailUseCaseProvider),
    ref.watch(saveProductUseCaseProvider),
    ref.watch(deleteProductUseCaseProvider),
  );
});

class ProductController extends StateNotifier<ProductState> {
  ProductController(
    this._getProductsUseCase,
    this._getProductDetailUseCase,
    this._saveProductUseCase,
    this._deleteProductUseCase,
  ) : super(const ProductState());

  final GetProductsUseCase _getProductsUseCase;
  final GetProductDetailUseCase _getProductDetailUseCase;
  final SaveProductUseCase _saveProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getProductsUseCase(const NoParams());
    state = result.when(
      success: (products) => state.copyWith(products: products, isLoading: false, clearError: true),
      failure: (failure) => state.copyWith(isLoading: false, errorMessage: failure.message),
    );
  }

  Future<Product?> findProduct(String id) async {
    final matchingProducts = state.products.where((product) => product.id == id);
    final cached = matchingProducts.isEmpty ? null : matchingProducts.first;
    if (cached != null) {
      return cached;
    }

    final result = await _getProductDetailUseCase(id);
    return result.when(success: (product) => product, failure: (_) => null);
  }

  Future<bool> saveProduct(Product product, {required bool isEditing}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _saveProductUseCase(
      SaveProductParams(product: product, isEditing: isEditing),
    );

    return result.when(
      success: (_) async {
        await loadProducts();
        return true;
      },
      failure: (failure) async {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> deleteProduct(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _deleteProductUseCase(id);

    return result.when(
      success: (_) async {
        await loadProducts();
        return true;
      },
      failure: (failure) async {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }
}
