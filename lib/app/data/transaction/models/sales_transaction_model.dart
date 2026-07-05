import 'transaction_item_model.dart';
import '../../../domain/transaction/entities/sales_transaction.dart';

class SalesTransactionModel {
  const SalesTransactionModel({
    required this.id,
    required this.invoiceNumber,
    required this.cashierName,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paidAmount,
    required this.changeAmount,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.createdAt,
  });

  final String id;
  final String invoiceNumber;
  final String cashierName;
  final List<TransactionItemModel> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final String paymentMethod;
  final double paidAmount;
  final double changeAmount;
  final double latitude;
  final double longitude;
  final String locationName;
  final DateTime createdAt;

  factory SalesTransactionModel.fromEntity(SalesTransaction transaction) {
    return SalesTransactionModel(
      id: transaction.id,
      invoiceNumber: transaction.invoiceNumber,
      cashierName: transaction.cashierName,
      items: transaction.items.map(TransactionItemModel.fromEntity).toList(),
      subtotal: transaction.subtotal,
      discount: transaction.discount,
      tax: transaction.tax,
      grandTotal: transaction.grandTotal,
      paymentMethod: transaction.paymentMethod,
      paidAmount: transaction.paidAmount,
      changeAmount: transaction.changeAmount,
      latitude: transaction.latitude,
      longitude: transaction.longitude,
      locationName: transaction.locationName,
      createdAt: transaction.createdAt,
    );
  }

  SalesTransaction toEntity() {
    return SalesTransaction(
      id: id,
      invoiceNumber: invoiceNumber,
      cashierName: cashierName,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      grandTotal: grandTotal,
      paymentMethod: paymentMethod,
      paidAmount: paidAmount,
      changeAmount: changeAmount,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      createdAt: createdAt,
    );
  }
}
