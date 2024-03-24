import 'package:flutter/material.dart';
import 'package:hackaton_project/model/adventure.dart';
import 'package:hackaton_project/model/stepstory.dart';

class FourthPage extends StatelessWidget {
  const FourthPage(
      {super.key,
      required this.title,
      required this.adventure,
      required this.stepStory});
  final String title;
  final Adventure adventure;
  final StepStory stepStory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Color.fromARGB(255, 187, 222, 251), Colors.white],
            ),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
