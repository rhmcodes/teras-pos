import '../../../domain/product/entities/product.dart';

class ProductState {
  const ProductState({
    this.products = const <Product>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
