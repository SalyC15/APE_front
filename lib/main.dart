import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const MediCityApp());

class MediCityApp extends StatelessWidget {
  const MediCityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCity Distribuido',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
