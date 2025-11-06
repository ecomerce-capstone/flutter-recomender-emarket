import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String trailing;
  const ProductListTile({
    required this.name,
    required this.subtitle,
    required this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(subtitle),
      trailing: Text(trailing),
    );
  }
}
