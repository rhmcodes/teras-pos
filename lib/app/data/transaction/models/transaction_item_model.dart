import '../../../domain/transaction/entities/transaction_item.dart';

class TransactionItemModel {
  const TransactionItemModel({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  factory TransactionItemModel.fromEntity(TransactionItem item) {
    return TransactionItemModel(
      productId: item.productId,
      productName: item.productName,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
    );
  }

  TransactionItem toEntity() {
    return TransactionItem(
      productId: productId,
      productName: productName,
      unitPrice: unitPrice,
      quantity: quantity,
    );
  }
}
