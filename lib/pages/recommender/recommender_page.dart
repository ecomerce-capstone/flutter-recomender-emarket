import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recommender_provider.dart';
import '../../widgets/charts/line_chart_widget.dart';
import '../../widgets/product_list_tile.dart';

class RecommenderPage extends StatefulWidget {
  @override
  State<RecommenderPage> createState() => _RecommenderPageState();
}

class _RecommenderPageState extends State<RecommenderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final rec = Provider.of<RecommenderProvider>(context, listen: false);
    rec.fetchTopProducts(limit: 20);
    rec.fetchTopByCategory(limitPerCategory: 5);
  }

  @override
  Widget build(BuildContext context) {
    final rec = Provider.of<RecommenderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommender'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Top Products'),
            Tab(text: 'By Category'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Top products tab
          rec.state == RecState.loading
              ? Center(child: CircularProgressIndicator())
              : rec.state == RecState.noData
              ? Center(child: Text('No Data'))
              : ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: LineChartWidget(
                        points: rec.topProducts
                            .map((p) => p.totalQty.toDouble())
                            .toList(),
                      ),
                    ),
                    ...rec.topProducts
                        .map(
                          (p) => ProductListTile(
                            name: p.name,
                            subtitle: 'Qty: ${p.totalQty}',
                            trailing: 'Rp ${p.totalRevenue.toStringAsFixed(0)}',
                          ),
                        )
                        .toList(),
                  ],
                ),

          // By category
          rec.state == RecState.loading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: rec.topByCategory.entries.map((e) {
                    final products = (e.value as List)
                        .map((p) => p['product_name'])
                        .toList();
                    return ExpansionTile(
                      title: Text('Category ${e.key}'),
                      children: products
                          .map((n) => ListTile(title: Text(n)))
                          .toList(),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
