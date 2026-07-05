import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

import '../data/auth/datasources/auth_local_datasource.dart';
import '../data/auth/repositories/dummy_auth_repository.dart';
import '../data/auth/repositories/firebase_auth_repository.dart';
import '../data/local/local_pos_database.dart';
import '../data/location/repositories/dummy_location_repository.dart';
import '../data/product/datasources/product_local_datasource.dart';
import '../data/product/repositories/dummy_product_repository.dart';
import '../data/product/repositories/firebase_product_repository.dart';
import '../data/receipt/repositories/dummy_receipt_repository.dart';
import '../data/report/repositories/dummy_report_repository.dart';
import '../data/transaction/datasources/transaction_local_datasource.dart';
import '../data/transaction/repositories/dummy_transaction_repository.dart';
import '../data/transaction/repositories/firebase_transaction_repository.dart';
import '../domain/auth/repositories/auth_repository.dart';
import '../domain/auth/usecases/forgot_password_usecase.dart';
import '../domain/auth/usecases/login_usecase.dart';
import '../domain/auth/usecases/logout_usecase.dart';
import '../domain/auth/usecases/register_usecase.dart';
import '../domain/location/repositories/location_repository.dart';
import '../domain/location/usecases/get_current_location_usecase.dart';
import '../domain/product/repositories/product_repository.dart';
import '../domain/product/usecases/delete_product_usecase.dart';
import '../domain/product/usecases/get_product_detail_usecase.dart';
import '../domain/product/usecases/get_products_usecase.dart';
import '../domain/product/usecases/save_product_usecase.dart';
import '../domain/receipt/repositories/receipt_repository.dart';
import '../domain/receipt/usecases/build_receipt_text_usecase.dart';
import '../domain/receipt/usecases/print_receipt_usecase.dart';
import '../domain/report/repositories/report_repository.dart';
import '../domain/report/usecases/export_sales_report_csv_usecase.dart';
import '../domain/report/usecases/get_sales_report_usecase.dart';
import '../domain/transaction/repositories/transaction_repository.dart';
import '../domain/transaction/usecases/create_transaction_usecase.dart';
import '../domain/transaction/usecases/get_transaction_detail_usecase.dart';
import '../domain/transaction/usecases/get_transactions_usecase.dart';
import '../services/file_service.dart';
import '../services/location_service.dart';
import '../services/permission_service.dart';
import '../services/report_export_service.dart';
import '../services/thermal_printer_service.dart';
import '../storage/local_storage.dart';
import '../storage/preference_storage.dart';

final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());

final preferenceStorageProvider = Provider<PreferenceStorage>(
  (ref) => PreferenceStorage(ref.watch(localStorageProvider)),
);

final localPosDatabaseProvider = Provider<LocalPosDatabase>((ref) => LocalPosDatabase());

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());
final thermalPrinterServiceProvider = Provider<ThermalPrinterService>((ref) => ThermalPrinterService());
final reportExportServiceProvider = Provider<ReportExportService>((ref) => ReportExportService());
final fileServiceProvider = Provider<FileService>((ref) => FileService());
final permissionServiceProvider = Provider<PermissionService>((ref) => PermissionService());

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => AuthLocalDataSource(ref.watch(localPosDatabaseProvider)),
);

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>(
  (ref) => ProductLocalDataSource(ref.watch(localPosDatabaseProvider)),
);

final transactionLocalDataSourceProvider = Provider<TransactionLocalDataSource>(
  (ref) => TransactionLocalDataSource(ref.watch(localPosDatabaseProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (AppConfig.useFirebaseRepositories) {
    return const FirebaseAuthRepository();
  }

  return DummyAuthRepository(ref.watch(authLocalDataSourceProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  if (AppConfig.useFirebaseRepositories) {
    return const FirebaseProductRepository();
  }

  return DummyProductRepository(ref.watch(productLocalDataSourceProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  if (AppConfig.useFirebaseRepositories) {
    return const FirebaseTransactionRepository();
  }

  return DummyTransactionRepository(ref.watch(transactionLocalDataSourceProvider));
});

final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => DummyLocationRepository(ref.watch(locationServiceProvider)),
);

final receiptRepositoryProvider = Provider<ReceiptRepository>(
  (ref) => DummyReceiptRepository(ref.watch(thermalPrinterServiceProvider)),
);

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => DummyReportRepository(
    ref.watch(transactionRepositoryProvider),
    ref.watch(reportExportServiceProvider),
    ref.watch(fileServiceProvider),
  ),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)),
);

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>(
  (ref) => ForgotPasswordUseCase(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.watch(authRepositoryProvider)),
);

final getProductsUseCaseProvider = Provider<GetProductsUseCase>(
  (ref) => GetProductsUseCase(ref.watch(productRepositoryProvider)),
);

final getProductDetailUseCaseProvider = Provider<GetProductDetailUseCase>(
  (ref) => GetProductDetailUseCase(ref.watch(productRepositoryProvider)),
);

final saveProductUseCaseProvider = Provider<SaveProductUseCase>(
  (ref) => SaveProductUseCase(ref.watch(productRepositoryProvider)),
);

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>(
  (ref) => DeleteProductUseCase(ref.watch(productRepositoryProvider)),
);

final buildReceiptTextUseCaseProvider = Provider<BuildReceiptTextUseCase>(
  (ref) => BuildReceiptTextUseCase(ref.watch(receiptRepositoryProvider)),
);

final printReceiptUseCaseProvider = Provider<PrintReceiptUseCase>(
  (ref) => PrintReceiptUseCase(ref.watch(receiptRepositoryProvider)),
);

final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocationUseCase>(
  (ref) => GetCurrentLocationUseCase(ref.watch(locationRepositoryProvider)),
);

final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>(
  (ref) => GetTransactionsUseCase(ref.watch(transactionRepositoryProvider)),
);

final getTransactionDetailUseCaseProvider = Provider<GetTransactionDetailUseCase>(
  (ref) => GetTransactionDetailUseCase(ref.watch(transactionRepositoryProvider)),
);

final createTransactionUseCaseProvider = Provider<CreateTransactionUseCase>(
  (ref) => CreateTransactionUseCase(ref.watch(transactionRepositoryProvider)),
);

final getSalesReportUseCaseProvider = Provider<GetSalesReportUseCase>(
  (ref) => GetSalesReportUseCase(ref.watch(reportRepositoryProvider)),
);

final exportSalesReportCsvUseCaseProvider = Provider<ExportSalesReportCsvUseCase>(
  (ref) => ExportSalesReportCsvUseCase(ref.watch(reportRepositoryProvider)),
);
