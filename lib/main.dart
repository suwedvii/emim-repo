import 'package:emim/screens/login/login.dart';
import 'package:emim/screens/splash_screen.dart';
import 'package:emim/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 36, 88, 5),
    brightness: Brightness.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      title: 'eMiM',
      theme: ThemeData().copyWith(
        dividerTheme: DividerTheme.of(context).copyWith(
          thickness: 2,
          color: lightColorScheme.primary,
          space: 8,
        ),
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
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const TabsScreen();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}
