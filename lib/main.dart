import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';
import 'package:flutter_place_finder/ui/pages/home/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/theme.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.buildTheme(),
      home: HomePage(),
    );
  }
}
