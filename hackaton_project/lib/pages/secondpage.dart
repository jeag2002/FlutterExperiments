import 'package:flutter/material.dart';
import 'package:hackaton_project/pages/tercerpage.dart';
import 'package:hackaton_project/model/adventure.dart';

//https://docs.flutter.dev/cookbook/animation/page-route-animation
//https://www.javatpoint.com/flutter-progress-bar#LinearProgressIndicator

class SecondPage extends StatelessWidget {
  const SecondPage({super.key, required this.title, required this.form});
  final String title;
  final Adventure form;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(title),
              automaticallyImplyLeading: false,
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
            body: SecondPageForm(adventure: form)));
  }
}

// Create a Form widget.
class SecondPageForm extends StatefulWidget {
  const SecondPageForm({super.key, required this.adventure});
  final Adventure adventure;

  @override
  SecondPageFormState createState() {
    // ignore: no_logic_in_create_state
    return SecondPageFormState(adventure: adventure);
  }
}

class SecondPageFormState extends State<SecondPageForm> {
  SecondPageFormState({required this.adventure});
  final _formKey = GlobalKey<FormState>();
  final Adventure adventure;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                      width: 500,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          adventure.choose = "Apocaliptic";
                          _formKey.currentState!.save();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TercerPage(
                                title:
                                    'Build your own adventure - Generating your story ${adventure.name.toUpperCase()}',
                                form: adventure);
                          }));
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: const Text('Apocaliptic'),
                      ))),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                      width: 500,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          adventure.choose = "Fantasy";
                          _formKey.currentState!.save();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TercerPage(
                                title:
                                    'Build your own adventure - Generating your story ${adventure.name.toUpperCase()}',
                                form: adventure);
                          }));
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: const Text('Fantasy'),
                      ))),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                      width: 500,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          adventure.choose = "Adventure";
                          _formKey.currentState!.save();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TercerPage(
                                title:
                                    'Build your own adventure - Generating your story ${adventure.name.toUpperCase()}',
                                form: adventure);
                          }));
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: const Text('Adventure'),
                      )))
            ])));
  }
}
