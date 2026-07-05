import 'sales_summary.dart';
import '../../transaction/entities/sales_transaction.dart';

class SalesReport {
  const SalesReport({
    required this.summary,
    required this.transactions,
    required this.startDate,
    required this.endDate,
  });

  final SalesSummary summary;
  final List<SalesTransaction> transactions;
  final DateTime startDate;
  final DateTime endDate;
}
