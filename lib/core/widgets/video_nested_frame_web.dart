// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// On the web, YouTube (and many video hosts) refuse to render inside an
/// iframe that is itself nested inside another iframe (common in preview
/// tools like the Replit editor's canvas/preview pane) due to
/// X-Frame-Options / frame-ancestors security policies. When that's the
/// case the embedded player would just show a blank box, so callers should
/// fall back to a "tap to watch on YouTube" link instead.
///
/// This file is only ever compiled for web builds via a conditional import
/// in `inline_video_player.dart` — it is never included in Android/iOS
/// builds, so it cannot break native compilation.
bool isRunningInNestedIframe() {
  try {
    return html.window.self != html.window.top;
  } catch (_) {
    // Cross-origin access to window.top throws — that itself means we're
    // nested inside a frame from a different origin.
    return true;
  }
}
