import 'package:flutter/material.dart';
import 'package:hackaton_project/pages/firstpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: backgroundImage(),
      child: materialAppManager(),
    );
  }

  BoxDecoration backgroundImage() {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/sunset.jpg'),
        fit: BoxFit.fill,
      ),
    );
  }

  MaterialApp materialAppManager() {
    return MaterialApp(
      title: 'Write your own adventure',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          surface: Color.fromARGB(255, 187, 222, 251),
          onSurface: Colors.black,
          // Colors that are not relevant to AppBar in DARK mode:
          primary: Colors.green,
          onPrimary: Colors.transparent,
          secondary: Colors.transparent,
          onSecondary: Colors.transparent,
          background: Colors.transparent,
          onBackground: Colors.transparent,
          error: Colors.red,
          onError: Colors.red,
        ),
      ),
      home: const FirstPage(title: 'Build your own adventure - Welcome!'),
    );
  }
}






/*
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Write your own adventure',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            surface: Colors.green,
            onSurface: Colors.black,
            // Colors that are not relevant to AppBar in DARK mode:
            primary: Colors.transparent,
            onPrimary: Colors.transparent,
            secondary: Colors.transparent,
            onSecondary: Colors.transparent,
            background: Colors.transparent,
            onBackground: Colors.transparent,
            error: Colors.transparent,
            onError: Colors.transparent,
          ),
        ),
        home: Scaffold(
            body: Stack(children: [
          backgroundImage(),
          const FirstPage(title: 'Build your own adventure'),
        ])));
  }

  Widget backgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/sunset.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }*/

  /*
  Widget backgroundImage() {
    return const SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image(
                image: AssetImage('assets/images/sunset.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          );
  }*/

  /*
    return MaterialApp(
      title: 'Write your own adventure',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          surface: Colors.green,
          onSurface: Colors.black,
          // Colors that are not relevant to AppBar in DARK mode:
          primary: Colors.lightGreen,
          onPrimary: Colors.lightGreen,
          secondary: Colors.lightGreen,
          onSecondary: Colors.lightGreen,
          background: Colors.lightGreen,
          onBackground: Colors.lightGreen,
          error: Colors.lightGreen,
          onError: Colors.lightGreen,
        ),
      ),
      home: const FirstPage(title: 'Build your own adventure'),
    );
    */
/*}*/
