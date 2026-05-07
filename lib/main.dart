import 'package:flutter/material.dart';
import 'package:focuslens_frontend/screens/home_screens.dart';


void main() {
  runApp(const FocusLensApp());
}

class FocusLensApp extends StatelessWidget {
  const FocusLensApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusLens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6200EE),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}