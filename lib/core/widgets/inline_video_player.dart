import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'video_nested_frame_stub.dart'
    if (dart.library.html) 'video_nested_frame_web.dart';

/// Extracts a YouTube video ID from common URL formats.
/// Returns null if [url] isn't a recognizable YouTube link.
String? extractYouTubeId(String url) {
  final patterns = [
    RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
    RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
    RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
    RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})'),
    RegExp(r'youtube\.com/live/([a-zA-Z0-9_-]{11})'),
  ];
  for (final p in patterns) {
    final m = p.firstMatch(url);
    if (m != null) return m.group(1);
  }
  return null;
}

/// A single widget that plays a video URL **inline**, right inside the app UI
/// — never in an external browser tab or a separate window. Works on Flutter
/// Web, Android and iOS:
///  * YouTube links -> rendered with `youtube_player_iframe` (uses a real
///    WebView on mobile and an <iframe> on web, but always embedded in the
///    page/screen, not launched externally).
///  * Direct video files (mp4/webm/mov/etc.) -> rendered with `video_player`
///    with basic play/pause/seek controls.
class InlineVideoPlayer extends StatefulWidget {
  final String url;
  final double aspectRatio;

  const InlineVideoPlayer({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  String? _youtubeId;

  @override
  void initState() {
    super.initState();
    _youtubeId = extractYouTubeId(widget.url);
  }

  @override
  void didUpdateWidget(covariant InlineVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _youtubeId = extractYouTubeId(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_youtubeId != null) {
      return _InlineYoutubePlayer(
        key: ValueKey('yt_${_youtubeId!}'),
        videoId: _youtubeId!,
        aspectRatio: widget.aspectRatio,
      );
    }
    return _InlineDirectVideoPlayer(
      key: ValueKey('vid_${widget.url}'),
      url: widget.url,
      aspectRatio: widget.aspectRatio,
    );
  }
}

// ── YouTube: embedded in-app via WebView/iframe, never external ────────────
class _InlineYoutubePlayer extends StatefulWidget {
  final String videoId;
  final double aspectRatio;

  const _InlineYoutubePlayer({
    super.key,
    required this.videoId,
    required this.aspectRatio,
  });

  @override
  State<_InlineYoutubePlayer> createState() => _InlineYoutubePlayerState();
}

class _InlineYoutubePlayerState extends State<_InlineYoutubePlayer> {
  YoutubePlayerController? _controller;
  bool _blockedByNestedFrame = false;

  @override
  void initState() {
    super.initState();
    // Some hosting contexts (e.g. a preview tool that shows this app inside
    // an iframe within another iframe) get blocked by YouTube's own
    // X-Frame-Options/frame-ancestors policy, which would otherwise render
    // as a blank box with no error. Detect that case up front and offer a
    // "watch on YouTube" tap-through instead. This never triggers on
    // Android/iOS (real WebView, not an iframe) or on a normally deployed
    // web app (not nested), so real users always get true inline playback.
    if (kIsWeb && isRunningInNestedIframe()) {
      _blockedByNestedFrame = true;
      return;
    }
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        playsInline: true,
        enableJavaScript: true,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _InlineYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _controller?.loadVideoById(videoId: widget.videoId);
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  Future<void> _openOnYoutube() async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=${widget.videoId}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (_blockedByNestedFrame) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: GestureDetector(
            onTap: _openOnYoutube,
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 64),
                  SizedBox(height: 8),
                  Text(
                    'Tap to watch on YouTube',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '(preview embedding is restricted here — plays\ninline normally on the published app and mobile)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: YoutubePlayer(controller: _controller!),
      ),
    );
  }
}

// ── Direct video file (mp4/webm/etc.) — inline playback with controls ──────
class _InlineDirectVideoPlayer extends StatefulWidget {
  final String url;
  final double aspectRatio;

  const _InlineDirectVideoPlayer({
    super.key,
    required this.url,
    required this.aspectRatio,
  });

  @override
  State<_InlineDirectVideoPlayer> createState() =>
      _InlineDirectVideoPlayerState();
}

class _InlineDirectVideoPlayerState extends State<_InlineDirectVideoPlayer> {
  VideoPlayerController? _controller;
  bool _error = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _initialized = true;
      });
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final c = _controller;
    if (c == null) return;
    setState(() {
      c.value.isPlaying ? c.pause() : c.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const Text(
            'Unable to load this video',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    if (!_initialized || _controller == null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final c = _controller!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(c),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _togglePlay,
              child: AnimatedBuilder(
                animation: c,
                builder: (context, _) {
                  if (c.value.isPlaying) return const SizedBox.expand();
                  return Container(
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 64,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: c,
                builder: (context, _) => VideoProgressIndicator(
                  c,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  colors: const VideoProgressColors(
                    playedColor: Colors.redAccent,
                    bufferedColor: Colors.white38,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
