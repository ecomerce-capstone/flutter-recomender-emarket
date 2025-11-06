import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recommender_provider.dart';
import '../../widgets/charts/line_chart_widget.dart';
import '../../widgets/product_list_tile.dart';
import 'package:intl/intl.dart';

class RecommenderPage extends StatefulWidget {
  const RecommenderPage({Key? key}) : super(key: key);
  @override
  State<RecommenderPage> createState() => _RecommenderPageState();
}

class _RecommenderPageState extends State<RecommenderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, String>> tabs = [
    {'key': 'top_products', 'label': 'Top Products'},
    {'key': 'top_vendors', 'label': 'Top Vendors'},
    {'key': 'trending_7d', 'label': 'Trending 7d'},
    {'key': 'monthly_top', 'label': 'Monthly Top'},
    {'key': 'by_category', 'label': 'By Category'},
  ];

  final TextEditingController _searchCtrl = TextEditingController();
  int _limit = 20;
  DateTimeRange? _pickedRange;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchForTabIndex(0));
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging)
        _fetchForTabIndex(_tabController.index);
    });
    _searchCtrl.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 350), () {
        _applyFiltersForCurrentTab();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String? _formatDate(DateTime? d) =>
      d == null ? null : DateFormat('yyyy-MM-dd').format(d);

  void _clearFilters() {
    setState(() {
      _searchCtrl.clear();
      _limit = 20;
      _pickedRange = null;
    });
    _applyFiltersForCurrentTab();
  }

  void _applyFiltersForCurrentTab() {
    final provider = Provider.of<RecommenderProvider>(context, listen: false);
    final key = tabs[_tabController.index]['key'];
    final q = _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim();
    final from = _pickedRange != null ? _formatDate(_pickedRange!.start) : null;
    final to = _pickedRange != null ? _formatDate(_pickedRange!.end) : null;

    if (key == 'top_products')
      provider.fetchTopProducts(limit: _limit, q: q, from: from, to: to);
    else if (key == 'top_vendors')
      provider.fetchTopVendors(limit: _limit, q: q, from: from, to: to);
    else if (key == 'trending_7d')
      provider.fetchTrending7(limit: _limit, q: q, from: from, to: to);
    else if (key == 'monthly_top')
      provider.fetchMonthlyTop(limit: _limit, q: q, from: from, to: to);
    else if (key == 'by_category')
      provider.fetchTopByCategory(
        limitPerCategory: _limit,
        q: q,
        from: from,
        to: to,
      );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 2);
    final initial =
        _pickedRange ??
        DateTimeRange(start: now.subtract(Duration(days: 30)), end: now);
    final range = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: now,
      initialDateRange: initial,
    );
    if (range != null) {
      setState(() => _pickedRange = range);
      _applyFiltersForCurrentTab();
    }
  }

  void _fetchForTabIndex(int idx) {
    final provider = Provider.of<RecommenderProvider>(context, listen: false);
    final key = tabs[idx]['key'];
    final q = _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim();
    final from = _pickedRange != null ? _formatDate(_pickedRange!.start) : null;
    final to = _pickedRange != null ? _formatDate(_pickedRange!.end) : null;

    if (key == 'top_products')
      provider.fetchTopProducts(limit: _limit, q: q, from: from, to: to);
    else if (key == 'top_vendors')
      provider.fetchTopVendors(limit: _limit, q: q, from: from, to: to);
    else if (key == 'trending_7d')
      provider.fetchTrending7(limit: _limit, q: q, from: from, to: to);
    else if (key == 'monthly_top')
      provider.fetchMonthlyTop(limit: _limit, q: q, from: from, to: to);
    else if (key == 'by_category')
      provider.fetchTopByCategory(
        limitPerCategory: _limit,
        q: q,
        from: from,
        to: to,
      );
  }

  @override
  Widget build(BuildContext context) {
    final rec = Provider.of<RecommenderProvider>(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search product or vendor...',
                  ),
                ),
              ),
              SizedBox(width: 8),
              DropdownButton<int>(
                value: _limit,
                items: [5, 10, 20, 50]
                    .map((e) => DropdownMenuItem(child: Text('$e'), value: e))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _limit = v);
                  _applyFiltersForCurrentTab();
                },
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                icon: Icon(Icons.date_range),
                label: Text(
                  _pickedRange == null
                      ? 'Date'
                      : '${_formatDate(_pickedRange!.start)} → ${_formatDate(_pickedRange!.end)}',
                ),
                onPressed: _pickDateRange,
              ),
              SizedBox(width: 8),
              ElevatedButton(onPressed: _clearFilters, child: Text('Clear')),
            ],
          ),
        ),
        Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: tabs.map((t) => Tab(text: t['label'])).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((t) {
              final key = t['key'];
              if (rec.state == RecState.loading)
                return Center(child: CircularProgressIndicator());
              if (rec.state == RecState.noData)
                return Center(child: Text('No data'));
              if (rec.state == RecState.error)
                return Center(child: Text('Error: ${rec.errorMessage}'));

              if (key == 'top_products') {
                return ListView(
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
                );
              } else if (key == 'top_vendors') {
                return ListView(
                  children: rec.topVendors.map<Widget>((v) {
                    final store =
                        (v['store_name'] ?? 'Vendor ${v['vendor_account_id']}')
                            .toString();
                    final revenue = v['total_revenue'].toString();
                    final qty = v['total_qty'].toString();
                    return ListTile(
                      title: Text(store),
                      subtitle: Text('Revenue: $revenue  Qty: $qty'),
                    );
                  }).toList(),
                );
              } else if (key == 'trending_7d') {
                return ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: LineChartWidget(
                        points: rec.trending
                            .map((e) => (e['total_qty_7d'] as num).toDouble())
                            .toList(),
                      ),
                    ),
                    ...rec.trending
                        .map(
                          (p) => ProductListTile(
                            name: p['product_name'],
                            subtitle: 'Qty: ${p['total_qty_7d']}',
                            trailing: 'Rp ${p['total_revenue_7d']}',
                          ),
                        )
                        .toList(),
                  ],
                );
              } else if (key == 'monthly_top') {
                return ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: LineChartWidget(
                        points: rec.monthlyTop
                            .map((e) => (e['total_qty_30d'] as num).toDouble())
                            .toList(),
                      ),
                    ),
                    ...rec.monthlyTop
                        .map(
                          (p) => ProductListTile(
                            name: p['product_name'],
                            subtitle: 'Qty: ${p['total_qty_30d']}',
                            trailing: 'Rp ${p['total_revenue_30d']}',
                          ),
                        )
                        .toList(),
                  ],
                );
              } else if (key == 'by_category') {
                return ListView(
                  children: rec.topByCategory.entries.map((e) {
                    final cat = e.key;
                    final products = e.value as List;
                    return ExpansionTile(
                      title: Text('Category $cat'),
                      children: products
                          .map<Widget>(
                            (p) => ListTile(
                              title: Text(p['product_name']),
                              subtitle: Text('Qty ${p['total_qty']}'),
                            ),
                          )
                          .toList(),
                    );
                  }).toList(),
                );
              }
              return Center(child: Text('Unknown tab'));
            }).toList(),
          ),
        ),
      ],
    );
  }
}
