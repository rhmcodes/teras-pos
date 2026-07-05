import '../../../domain/transaction/entities/transaction_item.dart';

class CartState {
  const CartState({this.items = const <TransactionItem>[]});

  final List<TransactionItem> items;

  double get subtotal => items.fold<double>(0, (total, item) => total + item.total);
  int get totalQuantity => items.fold<int>(0, (total, item) => total + item.quantity);
  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<TransactionItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
