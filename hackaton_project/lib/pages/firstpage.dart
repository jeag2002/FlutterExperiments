import 'package:flutter/material.dart';
import 'package:hackaton_project/pages/secondpage.dart';
import 'package:hackaton_project/model/adventure.dart';

//https://docs.flutter.dev/cookbook/animation/page-route-animation
//https://thinkdiff.net/how-to-create-validate-and-save-form-in-flutter-e80b4d2a70a4

class FirstPage extends StatelessWidget {
  const FirstPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: const FirstPageForm());
  }
}

// Create a Form widget.
class FirstPageForm extends StatefulWidget {
  const FirstPageForm({super.key});

  @override
  FirstPageFormState createState() {
    return FirstPageFormState();
  }
}

class FirstPageFormState extends State<FirstPageForm> {
  final _formKey = GlobalKey<FormState>();

  Adventure adventure = Adventure(name: "", choose: "", uuid: "");

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "What's your name, explorer?",
                      filled: true, //<-- SEE HERE
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    validator: (value) {
                      // ignore: avoid_print
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // ignore: avoid_print
                      adventure.name = value!;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        adventure.uuid = idGenerator();

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SecondPage(
                              title:
                                  'Build your own adventure - Choose your journey ${adventure.name.toUpperCase()}',
                              form: adventure);
                        }));
                      }
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: const Text('Start'),
                  )),
            ],
          ),
        ));
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
}
