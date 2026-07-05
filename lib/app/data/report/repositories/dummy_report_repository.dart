import '../../../core/exceptions/error_handler.dart';
import '../../../core/result/result.dart';
import '../../../domain/report/entities/exported_report.dart';
import '../../../domain/report/entities/sales_report.dart';
import '../../../domain/report/entities/sales_summary.dart';
import '../../../domain/report/repositories/report_repository.dart';
import '../../../domain/transaction/repositories/transaction_repository.dart';
import '../../../services/file_service.dart';
import '../../../services/report_export_service.dart';

class DummyReportRepository implements ReportRepository {
  DummyReportRepository(
    this._transactionRepository,
    this._exportService,
    this._fileService,
  );

  final TransactionRepository _transactionRepository;
  final ReportExportService _exportService;
  final FileService _fileService;

  @override
  Future<Result<SalesReport>> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final result = await _transactionRepository.getTransactions();
      return result.when(
        success: (transactions) {
          final filtered = transactions.where((transaction) {
            final date = transaction.createdAt;
            final afterStart = date.isAfter(startDate) || date.isAtSameMomentAs(startDate);
            final beforeEnd = date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
            return afterStart && beforeEnd;
          }).toList();

          final revenue = filtered.fold<double>(0, (total, item) => total + item.grandTotal);
          final itemsSold = filtered.fold<int>(0, (total, item) => total + item.totalItems);
          final average = filtered.isEmpty ? 0.0 : revenue / filtered.length;

          return Success<SalesReport>(
            SalesReport(
              summary: SalesSummary(
                totalRevenue: revenue,
                totalTransactions: filtered.length,
                totalItemsSold: itemsSold,
                averageTransaction: average,
              ),
              transactions: filtered,
              startDate: startDate,
              endDate: endDate,
            ),
          );
        },
        failure: Failed<SalesReport>.new,
      );
    } catch (error) {
      return Failed<SalesReport>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<ExportedReport>> exportSalesReportCsv(SalesReport report) async {
    try {
      final content = _exportService.toCsv(report);
      final fileName = 'sales_report_${DateTime.now().millisecondsSinceEpoch}.csv';
      final path = await _fileService.saveCsv(fileName: fileName, content: content);

      return Success<ExportedReport>(
        ExportedReport(
          fileName: fileName,
          path: path,
          content: content,
        ),
      );
    } catch (error) {
      return Failed<ExportedReport>(ErrorHandler.fromException(error));
    }
  }
}
