/// Performance Optimization Strategies for Music Player
///
/// This file contains best practices and optimization techniques
/// to make the music player more responsive and less laggy.
library;

// Strategy 1: Debounce Position Updates
// Use this in PlaybackProvider to reduce notification frequency
// Instead of notifying on every position update, batch them

class UpdateDebouncer {
  final Duration throttleDuration;
  DateTime? _lastUpdateTime;

  UpdateDebouncer({this.throttleDuration = const Duration(milliseconds: 100)});

  bool shouldUpdate() {
    final now = DateTime.now();
    if (_lastUpdateTime == null ||
        now.difference(_lastUpdateTime!).inMilliseconds >=
            throttleDuration.inMilliseconds) {
      _lastUpdateTime = now;
      return true;
    }
    return false;
  }
}

// Strategy 2: Use Selector for Provider
// In widgets: instead of context.watch<PlaybackProvider>()
// Use: context.select<PlaybackProvider, bool>((p) => p.isPlaying)

// Strategy 3: Use RepaintBoundary for complex UI sections
// Wrap expensive widgets to prevent redrawing parent tree

// Strategy 4: Cache images and data
// Use Image.asset with caching, lazy load network images

// Strategy 5: Optimize build methods
// - Use const constructors
// - Extract widgets into separate classes
// - Use SingleChildRenderObjectWidget for custom layouts

// Strategy 6: Reduce BackdropFilter usage
// BackdropFilter is expensive, use simpler alternatives:
// - Replace with simple Container with opacity
// - Or use ShaderMask for performance
