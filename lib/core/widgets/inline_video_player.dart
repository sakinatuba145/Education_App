import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'video_nested_frame_stub.dart'
    if (dart.library.html) 'video_nested_frame_web.dart';

/// Extracts a YouTube video ID from common URL formats (youtu.be, watch?v=,
/// embed/, shorts/, live/, m.youtube.com, with extra query params like
/// &t=30s or &list=..., etc). Returns null if [url] isn't a YouTube link.
///
/// Delegates to `YoutubePlayerController.convertUrlToId`, which is the
/// package's own battle-tested parser and covers far more URL shapes than a
/// hand-rolled regex would.
String? extractYouTubeId(String url) {
  return YoutubePlayerController.convertUrlToId(url);
}

/// File extensions that `video_player` can actually play directly.
const _directVideoExtensions = [
  '.mp4', '.mov', '.m4v', '.webm', '.ogg', '.ogv', '.m3u8', '.mkv', '.3gp',
];

/// Hosts that are known to serve raw, directly-playable video files even
/// when the URL itself has no recognizable file extension (e.g. Firebase
/// Storage download URLs, which end in a token, not `.mp4`).
const _directVideoHosts = [
  'firebasestorage.googleapis.com',
  'storage.googleapis.com',
];

/// Returns true if [url] looks like a direct, playable video file rather
/// than a "watch page" link (YouTube handled separately, this is for the
/// video_player fallback). Links to Google Drive, Dropbox, Vimeo, Facebook,
/// etc. "share" pages are NOT direct video files — those pages return HTML,
/// not a video stream, so `video_player` cannot play them and would only
/// ever show "Unable to load this video".
bool isLikelyDirectVideoUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  final path = uri.path.toLowerCase();
  if (_directVideoExtensions.any((ext) => path.endsWith(ext))) return true;
  final host = uri.host.toLowerCase();
  if (_directVideoHosts.any((h) => host.contains(h))) return true;
  return false;
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
    if (isLikelyDirectVideoUrl(widget.url)) {
      return _InlineDirectVideoPlayer(
        key: ValueKey('vid_${widget.url}'),
        url: widget.url,
        aspectRatio: widget.aspectRatio,
      );
    }
    // Not YouTube and not a direct video file (e.g. a Google Drive/Dropbox
    // "share" page link, a Vimeo/Facebook watch page, etc). Those pages
    // return HTML, not a video stream, so `video_player` cannot play them —
    // trying anyway just produces a confusing "unable to load" error.
    // Show a clear message and a tap-through instead of pretending it works.
    return _UnsupportedVideoSource(
      key: ValueKey('unsupported_${widget.url}'),
      url: widget.url,
      aspectRatio: widget.aspectRatio,
    );
  }
}

// ── Unsupported link (not YouTube, not a direct video file) ────────────────
class _UnsupportedVideoSource extends StatelessWidget {
  final String url;
  final double aspectRatio;

  const _UnsupportedVideoSource({
    super.key,
    required this.url,
    required this.aspectRatio,
  });

  Future<void> _openLink() async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: GestureDetector(
          onTap: _openLink,
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.link_off_rounded, color: Colors.white54, size: 40),
                SizedBox(height: 8),
                Text(
                  "This video link can't be played inline",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Only YouTube links and direct video files (.mp4 etc) '
                    'are supported. Tap to open the link instead.',
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
