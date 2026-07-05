class SalesSummary {
  const SalesSummary({
    required this.totalRevenue,
    required this.totalTransactions,
    required this.totalItemsSold,
    required this.averageTransaction,
  });

  final double totalRevenue;
  final int totalTransactions;
  final int totalItemsSold;
  final double averageTransaction;
}
