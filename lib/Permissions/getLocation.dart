import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class GetLocationPage extends StatefulWidget {
  const GetLocationPage({super.key});

  @override
  State<GetLocationPage> createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  String? latitude;
  String? longitude;
  bool isFetching = true; // Track if fetching is in progress

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          isFetching = false;
        });
        return;
      }
    }

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        latitude = currentPosition.latitude.toString();
        longitude = currentPosition.longitude.toString();
        isFetching = false;
      });

      log("Latitude- ${currentPosition.latitude}");
      log("Longitude- ${currentPosition.longitude}");
    } catch (e) {
      setState(() {
        isFetching = false;
      });
    }
  }

  void copyToClipboard() {
    if (latitude != null && longitude != null) {
      Clipboard.setData(ClipboardData(text: "$latitude, $longitude"));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "[SYSTEM MESSAGE]: Coordinates copied successfully!",
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'Courier',
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
        ),
      );
    }
  }


  void openInGoogleMaps() async {
    if (latitude != null && longitude != null) {
      String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Google Maps")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Location', style: TextStyle(color: Colors.greenAccent, fontFamily: 'Courier')),
        backgroundColor: Colors.black,
        leading: BackButton(
          color: Colors.green,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "[SYSTEM STATUS: ACTIVE]",
                style: TextStyle(fontSize: 16, color: Colors.redAccent, fontFamily: 'Courier'),
              ),
              const SizedBox(height: 20),
              if (isFetching)
                Column(
                  children: const [
                    Text(
                      "[FETCHING LOCATION...]",
                      style: TextStyle(fontSize: 18, color: Colors.greenAccent, fontFamily: 'Courier'),
                    ),
                    SizedBox(height: 10),
                    CircularProgressIndicator(color: Colors.greenAccent),
                  ],
                )
              else if (latitude != null && longitude != null) ...[
                const Text(
                  "[LOCATION CAPTURE SUCCESSFUL]",
                  style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent, fontFamily: 'Courier'),
                ),
                const SizedBox(height: 15),
                Text(
                  "Latitude: $latitude\nLongitude: $longitude",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.greenAccent, fontFamily: 'Courier'),
                ),
                const SizedBox(height: 20),
                const Text(
                  "=== COMMAND OPTIONS ===",
                  style: TextStyle(fontSize: 16, color: Colors.yellowAccent, fontFamily: 'Courier'),
                ),
                const SizedBox(height: 10),
                customOutlinedButton(Icons.copy, "Copy Coordinates", copyToClipboard),
                const SizedBox(height: 15),
                customOutlinedButton(Icons.map, "Open in Google Maps", openInGoogleMaps),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget customOutlinedButton(IconData icon, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // Full-width button
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.greenAccent),
        label: Text(label, style: const TextStyle(color: Colors.greenAccent, fontFamily: 'Courier')),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.greenAccent, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
