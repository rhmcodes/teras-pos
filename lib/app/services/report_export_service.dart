import '../core/utils/date_formatter.dart';
import '../domain/report/entities/sales_report.dart';

class ReportExportService {
  String toCsv(SalesReport report) {
    final buffer = StringBuffer()
      ..writeln('Invoice,Date,Cashier,Payment,Items,Subtotal,Discount,Tax,Grand Total,Location');

    for (final transaction in report.transactions) {
      buffer.writeln(
        <String>[
          transaction.invoiceNumber,
          DateFormatter.full(transaction.createdAt),
          transaction.cashierName,
          transaction.paymentMethod,
          transaction.totalItems.toString(),
          transaction.subtotal.toStringAsFixed(0),
          transaction.discount.toStringAsFixed(0),
          transaction.tax.toStringAsFixed(0),
          transaction.grandTotal.toStringAsFixed(0),
          transaction.locationName,
        ].map(_escape).join(','),
      );
    }

    return buffer.toString();
  }

  String _escape(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
