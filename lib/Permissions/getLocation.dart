import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GetLocationPage extends StatefulWidget {
  const GetLocationPage({super.key});

  @override
  State<GetLocationPage> createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  String locationMessage = "Fetching location...";

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location permission denied'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage = "Permission denied.";
        });
        return;
      }
    }

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        locationMessage = "Latitude: ${currentPosition.latitude}, Longitude: ${currentPosition.longitude}";
      });
      log("Latitude- ${currentPosition.latitude}");
      log("Longitude- ${currentPosition.longitude}");
    } catch (e) {
      setState(() {
        locationMessage = "Failed to get location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Center(
        child: Text(locationMessage, textAlign: TextAlign.center),
      ),
    );
  }
}
