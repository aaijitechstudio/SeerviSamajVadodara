import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool showControls;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        if (widget.autoPlay) {
          _controller.play();
          setState(() {
            _isPlaying = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        height: 200,
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Loading video...'),
            ],
          ),
        ),
      );
    }

    return VisibilityDetector(
      key: Key('video_${widget.videoUrl}'),
      onVisibilityChanged: (visibilityInfo) {
        // Auto-pause when video is not visible
        if (visibilityInfo.visibleFraction < 0.5 && _isPlaying) {
          _togglePlayPause();
        }
        // Auto-play when video becomes visible (if autoPlay is enabled)
        else if (visibilityInfo.visibleFraction >= 0.5 &&
            !_isPlaying &&
            widget.autoPlay) {
          _togglePlayPause();
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.showControls) {
            setState(() {
              _showControls = !_showControls;
            });
          }
        },
        child: Container(
          height: 200,
          color: Colors.black,
          child: Stack(
            children: [
              // Video Player
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),

              // Controls Overlay
              if (widget.showControls && _showControls) _buildControlsOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Column(
        children: [
          // Top Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () {
                  // Handle fullscreen
                },
              ),
            ],
          ),

          const Spacer(),

          // Center Play/Pause Button
          Center(
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
              onPressed: _togglePlayPause,
            ),
          ),

          const Spacer(),

          // Bottom Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress Bar
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.white,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                // Time and Fullscreen
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: () {
                        // Handle fullscreen
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
