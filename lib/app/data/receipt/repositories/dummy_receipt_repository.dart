import '../../../core/exceptions/error_handler.dart';
import '../../../core/result/result.dart';
import '../../../domain/receipt/repositories/receipt_repository.dart';
import '../../../domain/transaction/entities/sales_transaction.dart';
import '../../../services/thermal_printer_service.dart';

class DummyReceiptRepository implements ReceiptRepository {
  DummyReceiptRepository(this._thermalPrinterService);

  final ThermalPrinterService _thermalPrinterService;

  @override
  Future<Result<String>> buildReceiptText(SalesTransaction transaction) async {
    try {
      final receipt = await _thermalPrinterService.buildReceiptText(transaction);
      return Success<String>(receipt);
    } catch (error) {
      return Failed<String>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<void>> printReceipt(SalesTransaction transaction) async {
    try {
      await _thermalPrinterService.printReceipt(transaction);
      return const Success<void>(null);
    } catch (error) {
      return Failed<void>(ErrorHandler.fromException(error));
    }
  }
}
