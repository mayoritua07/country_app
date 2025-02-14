import 'package:countries_app/home_screen.dart';
import 'package:countries_app/theme_provider.dart';
import 'package:flutter/material.dart';

final theme = ThemeProvider();
String countriesUrl = "https://restcountries.com/v3.1/all";
String language = "eng";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void toggleTheme() {
    setState(() {
      theme.toggleTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: theme.themeMode,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(toggleTheme: toggleTheme),
    );
  }
}
// centralize text in text fielld input

///
///Name 
///State/provinces - language
///Flag
///Population
///Capital city - language
///Current President
///Continent - language
///Country code