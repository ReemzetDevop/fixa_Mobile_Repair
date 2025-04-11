import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  final bool showControls; // Parameter to toggle controls

  VideoWidget({required this.videoUrl, this.showControls = true});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool isLoading = true;
  bool isPlaying = false; // Track if the video is playing
  bool isMuted = false; // Track mute state

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
    _initializePlayer(file.path);
  }

  void _initializePlayer(String filePath) {
    _controller = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
          isPlaying = true; // Start playing after loading
        });
        _controller.play();
      });
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      isPlaying = !isPlaying; // Toggle play state
    });
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _controller.setVolume(isMuted ? 0 : 1); // Mute or unmute
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? Center(child: CircularProgressIndicator())
            : AspectRatio(
          aspectRatio: 9 / 16,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller),
              if (widget.showControls) _buildControls(), // Show controls if enabled
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,),
              onPressed: _togglePlayPause,
            ),
            IconButton(
              icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up,color: Colors.white,),
              onPressed: _toggleMute,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
