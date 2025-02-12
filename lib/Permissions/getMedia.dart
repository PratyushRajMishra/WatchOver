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
  bool isLoading = true;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final PermissionState status = await PhotoManager.requestPermissionExtend();

    if (status.isAuth) {
      setState(() {
        hasPermission = true;
      });
      _fetchAssets();
    } else {
      setState(() {
        hasPermission = false;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchAssets() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.all,  // Fetch both images and videos
    );

    List<AssetEntity> allMedia = [];
    for (var album in albums) {
      final media = await album.getAssetListPaged(page: 0, size: 100);
      allMedia.addAll(media);
    }

    setState(() {
      assets = allMedia;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const BackButton(color: Colors.green),
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
        child: Text(
          '[FETCHING MEDIA...]\n███████▒▒▒▒▒▒▒▒▒',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 20,
            fontFamily: 'Courier',
          ),
        ),
      )
          : hasPermission
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          final asset = assets[index];
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 2),
                ),
                child: AssetThumbnail(asset: asset),
              ),
              if (asset.type == AssetType.video) // Show play icon for videos
                const Positioned(
                  bottom: 5,
                  right: 5,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                ),
            ],
          );
        },
      )
          : const Center(
        child: Text(
          '4CC3SS D3N13D\nENABLE ST0R4G3 1N S3TT1NGS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 18,
            fontFamily: 'Courier',
          ),
        ),
      ),
    );
  }
}
