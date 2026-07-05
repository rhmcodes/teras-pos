import '../core/utils/currency_formatter.dart';
import '../core/utils/date_formatter.dart';
import '../domain/transaction/entities/sales_transaction.dart';

class ThermalPrinterService {
  Future<String> buildReceiptText(SalesTransaction transaction) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));

    final buffer = StringBuffer()
      ..writeln('TERAS POS')
      ..writeln('Jakarta Store Demo')
      ..writeln('------------------------------')
      ..writeln(transaction.invoiceNumber)
      ..writeln(DateFormatter.full(transaction.createdAt))
      ..writeln('Cashier: ${transaction.cashierName}')
      ..writeln('------------------------------');

    for (final item in transaction.items) {
      buffer
        ..writeln(item.productName)
        ..writeln('${item.quantity} x ${CurrencyFormatter.rupiah(item.unitPrice)} = ${CurrencyFormatter.rupiah(item.total)}');
    }

    buffer
      ..writeln('------------------------------')
      ..writeln('Subtotal : ${CurrencyFormatter.rupiah(transaction.subtotal)}')
      ..writeln('Discount : ${CurrencyFormatter.rupiah(transaction.discount)}')
      ..writeln('Tax      : ${CurrencyFormatter.rupiah(transaction.tax)}')
      ..writeln('Total    : ${CurrencyFormatter.rupiah(transaction.grandTotal)}')
      ..writeln('Paid     : ${CurrencyFormatter.rupiah(transaction.paidAmount)}')
      ..writeln('Change   : ${CurrencyFormatter.rupiah(transaction.changeAmount)}')
      ..writeln('------------------------------')
      ..writeln('Thank you');

    return buffer.toString();
  }

  Future<bool> printReceipt(SalesTransaction transaction) async {
    await buildReceiptText(transaction);
    return true;
  }
}
