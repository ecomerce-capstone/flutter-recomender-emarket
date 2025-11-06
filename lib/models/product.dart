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
      id: j['product_id'] is int
          ? j['product_id']
          : int.parse(j['product_id'].toString()),
      name: j['product_name'] ?? j['name'] ?? '',
      totalQty: (j['total_qty'] is int)
          ? j['total_qty']
          : (j['total_qty'] is num ? (j['total_qty'] as num).toInt() : 0),
      totalRevenue: (j['total_revenue'] is num)
          ? (j['total_revenue'] as num).toDouble()
          : double.tryParse((j['total_revenue'] ?? '0').toString()) ?? 0.0,
    );
  }
}
