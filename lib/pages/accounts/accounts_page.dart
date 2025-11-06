import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'User Profiles'),
                Tab(text: 'Vendor Profiles'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [UsersProfilesTab(), VendorsProfilesTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class UsersProfilesTab extends StatelessWidget {
  const UsersProfilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('User profiles list — implement API fetch'));
  }
}

class VendorsProfilesTab extends StatelessWidget {
  const VendorsProfilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Vendor profiles list — implement API fetch'));
  }
}
