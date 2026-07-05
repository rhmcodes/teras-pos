import 'transaction_item.dart';

class SalesTransaction {
  const SalesTransaction({
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
  final List<TransactionItem> items;
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

  int get totalItems => items.fold<int>(0, (total, item) => total + item.quantity);
}
