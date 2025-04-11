import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ServicePosterSliderWidget extends StatefulWidget {
  final List<String> mediaUrls;

  ServicePosterSliderWidget({required this.mediaUrls});

  @override
  _ServicePosterSliderWidgetState createState() => _ServicePosterSliderWidgetState();
}

class _ServicePosterSliderWidgetState extends State<ServicePosterSliderWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildMediaItem(String mediaUrl) {
    return mediaUrl.contains('.mp4')
        ? VideoWidget(videoUrl: mediaUrl)
        : Image.network(
      mediaUrl,
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: 250,
      initialPage: 0,
      indicatorColor: Colors.blue,
      indicatorBackgroundColor: Colors.grey,
      autoPlayInterval: 3500,
      isLoop: false,
      onPageChanged: (value) {
      },
      children: widget.mediaUrls.map((mediaUrl) => buildMediaItem(mediaUrl)).toList(),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  VideoWidget({required this.videoUrl});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setVolume(0);
        _controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
