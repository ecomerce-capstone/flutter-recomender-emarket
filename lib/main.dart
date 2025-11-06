import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/recommender_provider.dart';
import 'pages/accounts/accounts_page.dart';
import 'pages/recommender/recommender_page.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecommenderProvider()),
      ],
      child: MaterialApp(
        title: 'E-Marketplace',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeShell(),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    AccountsPage(),
    RecommenderPage(),
    Center(child: Text('More / Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('E-Marketplace')),
      drawer: _AppDrawer(
        onSelect: (index) {
          setState(() => _currentIndex = index);
          Navigator.pop(context);
        },
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Accounts'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Recommender',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final void Function(int) onSelect;
  const _AppDrawer({required this.onSelect, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(child: Text('Menu', style: TextStyle(fontSize: 22))),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Accounts'),
              onTap: () => onSelect(0),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Orders (soon)'),
              onTap: () => onSelect(2),
            ),
            ListTile(
              leading: Icon(Icons.recommend),
              title: Text('Recommendations'),
              onTap: () => onSelect(1),
            ),
          ],
        ),
      ),
    );
  }
}
