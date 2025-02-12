import 'package:flutter/material.dart';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:watchover/Permissions/getCallLogs.dart';
import 'package:watchover/Permissions/getContact.dart';
import 'package:watchover/Permissions/getDeviceInfoPage.dart';
import 'package:watchover/Permissions/getMedia.dart';
import 'package:watchover/Permissions/getMessages.dart';
import 'package:watchover/Permissions/getLocation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Location', 'icon': Icons.location_on, 'page': GetLocationPage()},
    {'title': 'Messages', 'icon': Icons.message, 'page': GetMessagesPage()},
    {'title': 'Contacts', 'icon': Icons.contacts, 'page': GetContactPage()},
    {'title': 'Call Logs', 'icon': Icons.call, 'page': GetCallLogsPage()},
    {'title': 'Media', 'icon': Icons.photo, 'page': GetMediaPage()},
    {'title': 'Device Info', 'icon': Icons.info, 'page': GetDeviceInfoPage()},
  ];

  final Map<Permission, bool> _permissionsStatus = {
    Permission.location: false,
    Permission.storage: false,
    Permission.contacts: false,
    Permission.sms: false,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
    _checkPermissions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    for (var permission in _permissionsStatus.keys) {
      _permissionsStatus[permission] = await permission.status.isGranted;
    }
    setState(() {});
  }

  Future<void> _togglePermission(Permission permission) async {
    if (await permission.status.isGranted) {
      openAppSettings();
    } else {
      final result = await permission.request();
      if (result.isGranted) {
        setState(() {
          _permissionsStatus[permission] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "WatchOver",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            fontFamily: 'monospace',
            shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: MatrixEffectPainter(_controller.value),
                child: Container(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menuItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => item['page']));
                        },
                        child: Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.greenAccent, width: 2),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: Colors.greenAccent.withOpacity(0.4), blurRadius: 10),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(item['icon'], size: 40, color: Colors.greenAccent),
                                const SizedBox(height: 10),
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                    fontFamily: 'monospace',
                                    shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 35),
                  Container(
                    alignment: Alignment.centerLeft, // Aligns text to the left
                    child: Text(
                      "PERMISSIONS",
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: _permissionsStatus.keys.map((permission) {
                      String permissionName = permission.toString().split('.').last.toUpperCase();
                      return Card(
                        color: Colors.black,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.greenAccent, width: 1.5),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.security, color: Colors.greenAccent),
                          title: Text(
                            permissionName,
                            style: GoogleFonts.sourceCodePro(
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                            ),
                          ),
                          trailing: Switch(
                            value: _permissionsStatus[permission] ?? false,
                            onChanged: (value) => _togglePermission(permission),
                            activeColor: Colors.black,
                            activeTrackColor: Colors.greenAccent,
                            inactiveTrackColor: Colors.white24,
                            inactiveThumbColor: Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MatrixEffectPainter extends CustomPainter {
  final double value;
  MatrixEffectPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint()..color = Colors.greenAccent.withOpacity(0.3);
    for (var i = 0; i < 200; i++) {
      double x = random.nextDouble() * size.width;
      double y = (random.nextDouble() * size.height) + (value * 20);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
