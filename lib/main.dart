import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/providers.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/profile/settings_screen.dart';
import 'screens/profile/character_creation_screen.dart';
import 'screens/firebase_test_screen.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: NinjaWorldMMOApp(),
    ),
  );
}

class NinjaWorldMMOApp extends ConsumerStatefulWidget {
  const NinjaWorldMMOApp({super.key});

  @override
  ConsumerState<NinjaWorldMMOApp> createState() => _NinjaWorldMMOAppState();
}

class _NinjaWorldMMOAppState extends ConsumerState<NinjaWorldMMOApp> {

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: '/profile/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/create-character',
          builder: (context, state) => const CharacterCreationScreen(),
        ),
        GoRoute(
          path: '/firebase-test',
          builder: (context, state) => const FirebaseTestScreen(),
        ),
      ],
      redirect: (context, state) {
        final authState = ref.watch(authStateProvider);
        final isAuthenticated = authState.isAuthenticated;
        final isOnAuthRoute = state.matchedLocation == '/login' || 
                             state.matchedLocation == '/register';
        final isOnSplash = state.matchedLocation == '/';

        // If not authenticated and not on auth route, redirect to login
        if (!isAuthenticated && !isOnAuthRoute && !isOnSplash) {
          return '/login';
        }

        // If authenticated and on auth route, redirect to main
        if (isAuthenticated && isOnAuthRoute) {
          return '/main';
        }

        // If authenticated and on splash, redirect to main
        if (isAuthenticated && isOnSplash) {
          return '/main';
        }

        return null;
      },
    );

    return MaterialApp.router(
      title: 'Ninja World MMO',
      theme: ThemeService().darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
