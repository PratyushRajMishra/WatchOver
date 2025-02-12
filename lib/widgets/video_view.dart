import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({
    Key? key,
    required this.videoFile,
  }) : super(key: key);

  final Future<File?> videoFile;

  @override
  State createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool initialized = false;

  _initVideo() async {
    final video = await widget.videoFile;
    if (video == null) return;

    _videoPlayerController = VideoPlayerController.file(video)
      ..setLooping(true)
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: true,
        );

        setState(() => initialized = true);
      });
  }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Hacker-style dark background
      appBar: AppBar(
        leading: const BackButton(color: Colors.green),
        backgroundColor: Colors.black,
        title: const Text(
          'VIDEO',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
        ),
        centerTitle: true,
      ),
      body: initialized
          ? Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(controller: _chewieController),
            ),
          ),
          Container(
            color: Colors.green.withOpacity(0.1), // Green tint overlay
          ),
        ],
      )
          : const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.greenAccent),
            SizedBox(height: 10),
            Text(
              'FETCHING...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 18,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
