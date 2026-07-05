import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/report/entities/sales_report.dart';
import '../../../shared/widgets/empty_state_widget.dart';

class ReportTable extends StatelessWidget {
  const ReportTable({
    super.key,
    required this.report,
  });

  final SalesReport report;

  @override
  Widget build(BuildContext context) {
    if (report.transactions.isEmpty) {
      return const EmptyStateWidget(
        title: 'No transactions found for this period',
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Invoice')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Cashier')),
          DataColumn(label: Text('Payment')),
          DataColumn(label: Text('Items')),
          DataColumn(label: Text('Total')),
        ],
        rows: report.transactions.map((transaction) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(transaction.invoiceNumber)),
              DataCell(Text(DateFormatter.full(transaction.createdAt))),
              DataCell(Text(transaction.cashierName)),
              DataCell(Text(transaction.paymentMethod)),
              DataCell(Text(transaction.totalItems.toString())),
              DataCell(Text(CurrencyFormatter.rupiah(transaction.grandTotal))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
