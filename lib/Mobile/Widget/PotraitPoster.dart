import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PotraitPoster extends StatefulWidget {
  @override
  _PotraitPosterState createState() => _PotraitPosterState();
}

class _PotraitPosterState extends State<PotraitPoster> {
  List<String> mediaUrls = [];
  List<String> mediaTypes = [];
  bool _isLoading = true;

  // Cache for video controllers
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirebase();
  }

  Future<void> _fetchDataFromFirebase() async {
    try {
      final databaseReference =
      FirebaseDatabase.instance.ref().child('/Fixa/PotraitPoster');
      final dataSnapshot = await databaseReference.once();

      if (dataSnapshot.snapshot.value != null) {
        final sliderData = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;
        final List<String> tempUrls = [];
        final List<String> tempTypes = [];

        sliderData.forEach((key, value) {
          final mediaUrl = value['url'] as String?;
          final mediaType = value['mediatype'] as String?;

          if (mediaUrl != null &&
              mediaType != null &&
              (mediaType == 'image' || mediaType == 'video')) {
            tempUrls.add(mediaUrl);
            tempTypes.add(mediaType);
          }
        });

        setState(() {
          mediaUrls = tempUrls;
          mediaTypes = tempTypes;
          _isLoading = false;
        });

        // Initialize video controllers
        _initializeVideoControllers();
      } else {
        print('No data found in Firebase');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error accessing Firebase: $e');
      setState(() => _isLoading = false);
    }
  }

  // Initialize video controllers only once
  void _initializeVideoControllers() {
    for (int i = 0; i < mediaUrls.length; i++) {
      if (mediaTypes[i] == 'video' && !_videoControllers.containsKey(mediaUrls[i])) {
        VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(mediaUrls[i]));

        _videoControllers[mediaUrls[i]] = controller;

        controller.initialize().then((_) {
          controller.setLooping(true);
          controller.setVolume(0);
          controller.play(); // ✅ Ensure video starts playing
          if (mounted) setState(() {}); // ✅ Trigger UI update after initialization
        }).catchError((error) {
          print('Error initializing video: $error');
        });
      }
    }
  }

  Widget _buildCarouselItem(BuildContext context, int index) {
    final mediaUrl = mediaUrls[index];
    final mediaType = mediaTypes[index];

    return Card(
      margin: EdgeInsets.all(4),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: mediaType == 'video'
            ? VideoWidget(controller: _videoControllers[mediaUrl]!)
            : Image.network(
          mediaUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (mediaUrls.isEmpty) {
      return SizedBox(); // Return empty if no media
    }

    return CarouselSlider.builder(
      itemCount: mediaUrls.length,
      itemBuilder: (context, index, realIndex) {
        return _buildCarouselItem(context, index);
      },
      options: CarouselOptions(
        autoPlay: false, // ✅ Disable auto-play because we handle video playback manually
        enlargeCenterPage: true,
        viewportFraction: 0.45,
        height: MediaQuery.of(context).size.height * 0.35,
      ),
    );
  }
}

// ✅ Video Widget (Uses Cached Controller)
class VideoWidget extends StatefulWidget {
  final VideoPlayerController controller;

  VideoWidget({required this.controller});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: VideoPlayer(widget.controller),
    )
        : Center(child: CircularProgressIndicator());
  }
}
