import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/report/entities/sales_report.dart';
import '../providers/report_provider.dart';
import '../widgets/report_table.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../router/app_routes.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => ref.read(reportControllerProvider.notifier).loadTodayReport());
  }

  Future<void> _export(SalesReport report) async {
    final success = await ref.read(reportControllerProvider.notifier).exportCsv(report);
    if (!mounted) {
      return;
    }

    if (!success) {
      return;
    }

    final reportState = ref.read(reportControllerProvider);
    final csv = reportState.csvContent ?? '';
    final exportPath = reportState.exportPath ?? 'simulated-downloads/sales_report.csv';
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('CSV Export Preview • $exportPath'),
          content: SingleChildScrollView(child: SelectableText(csv)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportControllerProvider);
    final report = state.report;

    return AppPage(
      title: 'Sales Report',
      showBackButton: true,
      onBackPressed: () => context.go(AppRoutes.dashboardPath),
      actions: <Widget>[
        IconButton(
          onPressed: report == null ? null : () => _export(report),
          icon: const Icon(Icons.download_outlined),
        ),
      ],
      child: Builder(
        builder: (context) {
          if (state.isLoading && report == null) {
            return const LoadingWidget(message: 'Calculating sales report...');
          }

          if (state.errorMessage != null && report == null) {
            return AppErrorWidget(
              message: state.errorMessage!,
              onRetry: () => ref.read(reportControllerProvider.notifier).loadTodayReport(),
            );
          }

          if (report == null) {
            return const EmptyStateWidget(title: 'Report is not available yet');
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 56),
            children: <Widget>[
              Text(
                '${DateFormatter.short(report.startDate)} - ${DateFormatter.short(report.endDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: 'Total Revenue',
                value: CurrencyFormatter.rupiah(report.summary.totalRevenue),
                icon: Icons.payments_outlined,
              ),
              MetricCard(
                title: 'Transactions',
                value: report.summary.totalTransactions.toString(),
                icon: Icons.receipt_long_outlined,
              ),
              MetricCard(
                title: 'Items Sold',
                value: report.summary.totalItemsSold.toString(),
                icon: Icons.inventory_2_outlined,
              ),
              MetricCard(
                title: 'Average Transaction',
                value: CurrencyFormatter.rupiah(report.summary.averageTransaction),
                icon: Icons.analytics_outlined,
              ),
              const SizedBox(height: 16),
              Text('Table View', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ReportTable(report: report),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
