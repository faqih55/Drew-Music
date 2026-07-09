import 'package:flutter/material.dart';

class AppConstants {
  // Theme Colors (Spotify Inspired)
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color surfaceLight = Color(0xFF2C2C2E);
  static const Color accent = Color(0xFF1ED760);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color glassBorder = Color(0x1FFFFFFF);

  // Spotify API Endpoints
  static const String spotifyAuthUrl = 'https://accounts.spotify.com/api/token';
  static const String spotifyBaseUrl = 'https://api.spotify.com/v1';

  // SharedPreferences Keys
  static const String keyClientId = 'spotify_client_id';
  static const String keyClientSecret = 'spotify_client_secret';
  static const String keyFavorites = 'spotify_favorites';
  static const String keyDemoMode = 'spotify_demo_mode';
  static const String keyRecentlyPlayed = 'spotify_recently_played';

  // Sample Tracks for Demo Mode (High Quality Royalty-Free MP3s & Unsplash Images)
  static const List<Map<String, dynamic>> demoTracks = [
    {
      'id': 'demo_1',
      'name': 'Midnight Drive',
      'artists': [
        {'name': 'Lofi Waves'},
      ],
      'album': {
        'name': 'Chill Sunset Vibes',
        'images': [
          {
            'url':
                'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500&auto=format&fit=crop&q=60',
          },
        ],
      },
      'duration_ms': 372000,
      'preview_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'id': 'demo_2',
      'name': 'Neon Lights',
      'artists': [
        {'name': 'Retro Synth'},
      ],
      'album': {
        'name': 'Cyberpunk Metropolis',
        'images': [
          {
            'url':
                'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=500&auto=format&fit=crop&q=60',
          },
        ],
      },
      'duration_ms': 423000,
      'preview_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'id': 'demo_3',
      'name': 'Summer Acoustic',
      'artists': [
        {'name': 'Folk & Co'},
      ],
      'album': {
        'name': 'Warm Campfire Session',
        'images': [
          {
            'url':
                'https://images.unsplash.com/photo-1498038432885-c6f3f1b912ee?w=500&auto=format&fit=crop&q=60',
          },
        ],
      },
      'duration_ms': 302000,
      'preview_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
    {
      'id': 'demo_4',
      'name': 'Ethereal Dreams',
      'artists': [
        {'name': 'Ambient Echoes'},
      ],
      'album': {
        'name': 'Nebula Explorations',
        'images': [
          {
            'url':
                'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=500&auto=format&fit=crop&q=60',
          },
        ],
      },
      'duration_ms': 388000,
      'preview_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    },
    {
      'id': 'demo_5',
      'name': 'Acoustic Breeze',
      'artists': [
        {'name': 'Guitar Nomad'},
      ],
      'album': {
        'name': 'Islands of Calm',
        'images': [
          {
            'url':
                'https://images.unsplash.com/photo-1507838153414-b4b713384a76?w=500&auto=format&fit=crop&q=60',
          },
        ],
      },
      'duration_ms': 305000,
      'preview_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    },
  ];
}
