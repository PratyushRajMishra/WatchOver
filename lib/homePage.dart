import 'package:flutter/material.dart';

import 'Permissions/getLocation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WatchOver'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item clicks here
              switch (value) {
                case 'Profile':
                  print('Profile selected');
                  break;
                case 'Settings':
                  print('Settings selected');
                  break;
                case 'Logout':
                  print('Logout selected');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'View Profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'Manage Permission',
                  child: Text('Settings'),
                ),
                const PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetLocationPage(),
                  ),
                );
              },
              child: Text('Location'),
            )
          ],
        ),
      ),
    );
  }
}
