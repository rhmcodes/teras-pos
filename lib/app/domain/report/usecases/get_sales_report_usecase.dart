import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/sales_report.dart';
import '../repositories/report_repository.dart';

class GetSalesReportUseCase extends BaseUseCase<SalesReport, SalesReportParams> {
  GetSalesReportUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<Result<SalesReport>> call(SalesReportParams params) {
    return _repository.getSalesReport(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class SalesReportParams {
  const SalesReportParams({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}
