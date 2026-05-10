import 'package:bear_animation_auth_pages/Providers/auth_page_change_provider.dart';
import 'package:bear_animation_auth_pages/ui/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const seed = Color.fromARGB(255, 149, 151, 241);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return ChangeNotifierProvider(
      create: (BuildContext context) => AuthPageChangeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Training',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: colorScheme.surface,
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            surfaceTintColor: colorScheme.surfaceTint,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              elevation: 2,
              shadowColor: colorScheme.shadow.withValues(alpha: 0.25),
            ),
          ),
        ),
        home: const AuthPage(),
      ),
    );
  }
}
