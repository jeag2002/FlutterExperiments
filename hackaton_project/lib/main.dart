// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hackaton_project/pages/firstpage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//https://github.com/tekartik/sqflite/tree/master/packages_web/sqflite_common_ffi_web#setup-binaries

void main() async {
  sqfliteFfiInit();
  if (!kIsWeb) {
    databaseFactory = databaseFactoryFfi;
  } else {
    databaseFactory = databaseFactoryFfiWebNoWebWorker;
  }

  WidgetsFlutterBinding.ensureInitialized();

  MainApp app = const MainApp();
  runApp(app);
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
          primary: Colors.black,
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
