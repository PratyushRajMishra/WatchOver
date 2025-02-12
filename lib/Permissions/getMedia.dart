import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../widgets/asset_thumbnail.dart';

class GetMediaPage extends StatefulWidget {
  const GetMediaPage({super.key});

  @override
  State<GetMediaPage> createState() => _GetMediaPageState();
}

class _GetMediaPageState extends State<GetMediaPage> {
  List<AssetEntity> assets = [];
  bool isLoading = true; // Track loading state

  Future<void> _fetchAssets() async {
    assets = await PhotoManager.getAssetListRange(
      start: 0,
      end: 100000,
    );

    setState(() {
      isLoading = false; // Set to false after fetching
    });
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: isLoading
          ? const Center(
        child: Text(
          'Fetching media...',
        ),
      )
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(
            asset: assets[index],
          );
        },
      ),
    );
  }
}
