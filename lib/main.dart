import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/recommender_provider.dart';
import 'pages/auth/login_page.dart';
import 'pages/recommender/recommender_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        home: LoginPage(),
        routes: {'/recommender': (_) => RecommenderPage()},
      ),
    );
  }
}
