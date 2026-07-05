import '../../../core/result/result.dart';
import '../../transaction/entities/sales_transaction.dart';

abstract class ReceiptRepository {
  Future<Result<String>> buildReceiptText(SalesTransaction transaction);
  Future<Result<void>> printReceipt(SalesTransaction transaction);
}
