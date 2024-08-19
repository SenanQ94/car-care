import 'package:linexo_demo/pages/auth/auth_screen.dart';
import 'package:linexo_demo/providers/articles_provider.dart';
import 'package:linexo_demo/providers/auth_service.dart';
import 'package:linexo_demo/providers/contact_provider.dart';
import 'package:linexo_demo/providers/language_provider.dart';
import 'package:linexo_demo/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpers/app_localizations.dart';
import 'helpers/config.dart';

import 'pages/home_page.dart';
import 'providers/videos_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: Config.firebaseOptions);

  final LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.setDefaultLanguage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider(create: (_) => ArticlesProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Linexo',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('de'),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (userSnapshot.hasData) {
          final user = userSnapshot.data;
          if (user != null) {
            return FutureBuilder<bool>(
              future: authService.isCurrentUserEmailVerified(),
              builder: (context, emailVerificationSnapshot) {
                if (emailVerificationSnapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingScreen();
                } else if (emailVerificationSnapshot.hasData && emailVerificationSnapshot.data == true) {
                  return const HomePage();
                } else {
                  return const AuthScreen();
                }
              },
            );
          } else {
            return const AuthScreen();
          }
        } else {
          return const AuthScreen();
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Image.asset(
              'assets/images/loading.gif',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}

