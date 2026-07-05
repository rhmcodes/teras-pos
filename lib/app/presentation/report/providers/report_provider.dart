import 'package:flutter_riverpod/legacy.dart';

import '../../../domain/report/entities/sales_report.dart';
import '../../../domain/report/usecases/export_sales_report_csv_usecase.dart';
import '../../../domain/report/usecases/get_sales_report_usecase.dart';
import '../../../injection/app_providers.dart';
import '../states/report_state.dart';

final reportControllerProvider = StateNotifierProvider<ReportController, ReportState>((ref) {
  return ReportController(
    ref.watch(getSalesReportUseCaseProvider),
    ref.watch(exportSalesReportCsvUseCaseProvider),
  );
});

class ReportController extends StateNotifier<ReportState> {
  ReportController(
    this._getSalesReportUseCase,
    this._exportSalesReportCsvUseCase,
  ) : super(const ReportState());

  final GetSalesReportUseCase _getSalesReportUseCase;
  final ExportSalesReportCsvUseCase _exportSalesReportCsvUseCase;

  Future<void> loadTodayReport() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    await loadReport(startDate: start, endDate: end);
  }

  Future<void> loadReport({required DateTime startDate, required DateTime endDate}) async {
    state = state.copyWith(isLoading: true, clearError: true, clearCsv: true);
    final result = await _getSalesReportUseCase(
      SalesReportParams(startDate: startDate, endDate: endDate),
    );

    state = result.when(
      success: (report) => state.copyWith(report: report, isLoading: false, clearError: true),
      failure: (failure) => state.copyWith(isLoading: false, errorMessage: failure.message),
    );
  }

  Future<bool> exportCsv(SalesReport report) async {
    state = state.copyWith(isLoading: true, clearError: true, clearCsv: true);
    final result = await _exportSalesReportCsvUseCase(report);

    return result.when(
      success: (exportedReport) {
        state = state.copyWith(
          csvContent: exportedReport.content,
          exportPath: exportedReport.path,
          isLoading: false,
          clearError: true,
        );
        return true;
      },
      failure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
    );
  }
}
