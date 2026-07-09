import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/youtube_music_service.dart';

class MusicProvider extends ChangeNotifier {
  final YoutubeMusicService _musicService;

  MusicProvider(this._musicService);

  List<Track> _recommendations = [];
  Map<String, List<Track>> _categorizedRecommendations = {};
  List<Track> _searchResults = [];
  bool _isLoadingRecommendations = false;
  bool _isLoadingSearch = false;
  String _errorMessage = '';

  List<Track> get recommendations => _recommendations;
  Map<String, List<Track>> get categorizedRecommendations => _categorizedRecommendations;
  List<Track> get searchResults => _searchResults;
  bool get isLoadingRecommendations => _isLoadingRecommendations;
  bool get isLoadingSearch => _isLoadingSearch;
  String get errorMessage => _errorMessage;

  Future<void> loadRecommendations({bool force = false}) async {
    if (!force && _categorizedRecommendations.isNotEmpty) return;

    _isLoadingRecommendations = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _categorizedRecommendations = await _musicService.getCategorizedRecommendations();
      // Flatten the map for components that still need a simple list (like HomeScreen)
      final List<Track> allTracks = [];
      for (var list in _categorizedRecommendations.values) {
        allTracks.addAll(list);
      }
      allTracks.shuffle();
      _recommendations = allTracks;
    } catch (e) {
      _errorMessage = 'Failed to load recommendations: $e';
    } finally {
      _isLoadingRecommendations = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoadingSearch = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _searchResults = await _musicService.searchTracks(query);
    } catch (e) {
      _errorMessage = 'Failed to search tracks: $e';
    } finally {
      _isLoadingSearch = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
