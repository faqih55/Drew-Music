import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/track.dart';
import '../core/constants.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initializes the SharedPreferences instance and returns the StorageService.
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Gets the saved Spotify Client ID.
  String? getClientId() => _prefs.getString(AppConstants.keyClientId);

  /// Saves the Spotify Client ID.
  Future<bool> saveClientId(String value) =>
      _prefs.setString(AppConstants.keyClientId, value.trim());

  /// Gets the saved Spotify Client Secret.
  String? getClientSecret() => _prefs.getString(AppConstants.keyClientSecret);

  /// Saves the Spotify Client Secret.
  Future<bool> saveClientSecret(String value) =>
      _prefs.setString(AppConstants.keyClientSecret, value.trim());

  /// Clears stored Spotify credentials.
  Future<void> clearCredentials() async {
    await _prefs.remove(AppConstants.keyClientId);
    await _prefs.remove(AppConstants.keyClientSecret);
  }

  /// Checks if Demo Mode is enabled (defaults to true).
  bool getDemoMode() => _prefs.getBool(AppConstants.keyDemoMode) ?? true;

  /// Toggles and saves the Demo Mode state.
  Future<bool> saveDemoMode(bool value) =>
      _prefs.setBool(AppConstants.keyDemoMode, value);

  /// Retrieves the saved favorite tracks list.
  List<Track> getFavorites() {
    final list = _prefs.getStringList(AppConstants.keyFavorites) ?? [];
    try {
      return list
          .map(
            (item) => Track.fromMap(jsonDecode(item) as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      // Return empty list if there's any corruption or structure updates
      return [];
    }
  }

  /// Saves the list of favorite tracks.
  Future<bool> saveFavorites(List<Track> tracks) async {
    final list = tracks.map((t) => jsonEncode(t.toMap())).toList();
    return _prefs.setStringList(AppConstants.keyFavorites, list);
  }

  /// Retrieves the list of recently played tracks.
  List<Track> getRecentlyPlayed() {
    final list = _prefs.getStringList(AppConstants.keyRecentlyPlayed) ?? [];
    try {
      return list
          .map(
            (item) => Track.fromMap(jsonDecode(item) as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Saves the list of recently played tracks (max limit should be handled before calling this).
  Future<bool> saveRecentlyPlayed(List<Track> tracks) async {
    final list = tracks.map((t) => jsonEncode(t.toMap())).toList();
    return _prefs.setStringList(AppConstants.keyRecentlyPlayed, list);
  }
}
