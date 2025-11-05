class Product {
  final int id;
  final String name;
  final int totalQty;
  final double totalRevenue;

  Product({
    required this.id,
    required this.name,
    required this.totalQty,
    required this.totalRevenue,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['product_id'] ?? j['id'],
      name: j['product_name'] ?? j['name'],
      totalQty: j['total_qty'] ?? 0,
      totalRevenue: (j['total_revenue'] is num)
          ? (j['total_revenue'] as num).toDouble()
          : 0.0,
    );
  }
}
