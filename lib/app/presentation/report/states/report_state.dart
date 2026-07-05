import '../../../domain/report/entities/sales_report.dart';

class ReportState {
  const ReportState({
    this.report,
    this.csvContent,
    this.exportPath,
    this.isLoading = false,
    this.errorMessage,
  });

  final SalesReport? report;
  final String? csvContent;
  final String? exportPath;
  final bool isLoading;
  final String? errorMessage;

  ReportState copyWith({
    SalesReport? report,
    String? csvContent,
    String? exportPath,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearCsv = false,
  }) {
    return ReportState(
      report: report ?? this.report,
      csvContent: clearCsv ? null : csvContent ?? this.csvContent,
      exportPath: clearCsv ? null : exportPath ?? this.exportPath,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
