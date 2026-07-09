import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/playback_provider.dart';
import 'providers/music_provider.dart';
import 'providers/auth_provider.dart';
import 'services/audio_service.dart';
import 'services/youtube_music_service.dart';
import 'services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'ui/screens/splash_screen.dart';
import 'ui/theme.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Initialize background services
  final storageService = await StorageService.init();
  final youtubeMusicService = YoutubeMusicService();
  final audioService = AudioService();

  runApp(
    MultiProvider(
      providers: [
        // Provide low-level services
        Provider<StorageService>.value(value: storageService),
        Provider<YoutubeMusicService>.value(value: youtubeMusicService),
        Provider<AudioService>.value(value: audioService),

        // Provide state management models
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<MusicProvider>(
          create: (_) => MusicProvider(youtubeMusicService),
        ),
        ChangeNotifierProvider<PlaybackProvider>(
          create: (_) => PlaybackProvider(
            audioService: audioService,
            storageService: storageService,
            musicService: youtubeMusicService,
          ),
        ),
      ],
      child: const YTMusicApp(),
    ),
  );
}

class YTMusicApp extends StatelessWidget {
  const YTMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XDREW V1',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
