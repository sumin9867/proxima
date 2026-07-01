import 'package:flutter/foundation.dart';

/// App-wide user preferences that outlive a single screen: the display name
/// shown to peers and whether calls default to video.
class AppSettings extends ChangeNotifier {
  AppSettings({String displayName = 'You', bool video = true})
      : _displayName = displayName,
        _video = video;

  String _displayName;
  bool _video;

  String get displayName => _displayName;
  bool get video => _video;

  set displayName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == _displayName) return;
    _displayName = trimmed;
    notifyListeners();
  }

  set video(bool value) {
    if (value == _video) return;
    _video = value;
    notifyListeners();
  }
}
