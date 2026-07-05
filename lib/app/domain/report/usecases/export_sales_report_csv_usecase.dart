import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/exported_report.dart';
import '../entities/sales_report.dart';
import '../repositories/report_repository.dart';

class ExportSalesReportCsvUseCase extends BaseUseCase<ExportedReport, SalesReport> {
  ExportSalesReportCsvUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<Result<ExportedReport>> call(SalesReport params) {
    return _repository.exportSalesReportCsv(params);
  }
}
