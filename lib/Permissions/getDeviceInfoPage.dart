import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class GetDeviceInfoPage extends StatefulWidget {
  const GetDeviceInfoPage({super.key});

  @override
  State<GetDeviceInfoPage> createState() => _GetDeviceInfoPageState();
}

class _GetDeviceInfoPageState extends State<GetDeviceInfoPage> {
  Map<String, String> deviceInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDeviceDetails();
  }

  Future<void> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String> info = {};

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      info = {
        "Model": androidInfo.model,
        "Manufacturer": androidInfo.manufacturer,
        "Brand": androidInfo.brand,
        "Device": androidInfo.device,
        "Product": androidInfo.product,
        "Android Version": androidInfo.version.release,
        "API Level": androidInfo.version.sdkInt.toString(),
        "Hardware": androidInfo.hardware,
        "Board": androidInfo.board,
        "Host": androidInfo.host,
        "ID": androidInfo.id,
        "Fingerprint": androidInfo.fingerprint,
        "Physical Device": androidInfo.isPhysicalDevice.toString(),
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      info = {
        "Name": iosInfo.name,
        "Model": iosInfo.model,
        "System Name": iosInfo.systemName,
        "System Version": iosInfo.systemVersion,
        "Identifier for Vendor": iosInfo.identifierForVendor ?? "N/A",
        "Physical Device": iosInfo.isPhysicalDevice.toString(),
      };
    }

    setState(() {
      deviceInfo = info;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: Text('Fetching Device info...'))
            : ListView.builder(
          itemCount: deviceInfo.length,
          itemBuilder: (context, index) {
            String key = deviceInfo.keys.elementAt(index);
            String value = deviceInfo[key]!;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Colors.deepPurple,
                ),
                title: Text(
                  key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
