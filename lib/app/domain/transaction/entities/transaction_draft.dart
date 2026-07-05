import 'transaction_item.dart';

class TransactionDraft {
  const TransactionDraft({
    required this.items,
    required this.cashierName,
    required this.paymentMethod,
    required this.paidAmount,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.discount = 0,
    this.tax = 0,
  });

  final List<TransactionItem> items;
  final String cashierName;
  final String paymentMethod;
  final double paidAmount;
  final double discount;
  final double tax;
  final double latitude;
  final double longitude;
  final String locationName;
}
