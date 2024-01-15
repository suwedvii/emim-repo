import 'package:emim/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 36, 88, 5),
    brightness: Brightness.light);

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        textTheme: GoogleFonts.latoTextTheme().copyWith(),
        colorScheme: lightColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            type: BottomNavigationBarType.fixed),
      ),
      home: const LoginScreen(),
    );
  }
}
