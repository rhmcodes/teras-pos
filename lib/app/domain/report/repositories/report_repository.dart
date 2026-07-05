import '../../../core/result/result.dart';
import '../entities/exported_report.dart';
import '../entities/sales_report.dart';

abstract class ReportRepository {
  Future<Result<SalesReport>> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Result<ExportedReport>> exportSalesReportCsv(SalesReport report);
}
