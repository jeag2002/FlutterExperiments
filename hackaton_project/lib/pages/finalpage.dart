// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackaton_project/model/adventure.dart';
import 'package:hackaton_project/db/storydatabase.dart';
import 'package:hackaton_project/mail/mail.dart';
import 'package:hackaton_project/mail/mail_web.dart';
import 'dart:io' show exit;
// ignore: unused_import, avoid_web_libraries_in_flutter

//https://stackoverflow.com/questions/66615417/flutter-web-how-can-i-close-my-app-through-code

class FinalPage extends StatelessWidget {
  const FinalPage(
      {super.key,
      required this.title,
      required this.adventure,
      required this.finalStory});
  final String title;
  final Adventure adventure;
  final String finalStory;
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
            body: FinalPageForm(finalStory: finalStory, adventure: adventure)));
  }
}

class FinalPageForm extends StatefulWidget {
  const FinalPageForm({
    super.key,
    required this.finalStory,
    required this.adventure,
  });
  final String finalStory;
  final Adventure adventure;
  @override
  FinalPageFormState createState() {
    // ignore: no_logic_in_create_state
    return FinalPageFormState(adventure: adventure, finalStory: finalStory);
  }
}

class FinalPageFormState extends State<FinalPageForm> {
  FinalPageFormState({required this.adventure, required this.finalStory});
  final _formKey = GlobalKey<FormState>();
  final Adventure adventure;
  final String finalStory;

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
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: FractionallySizedBox(
                    widthFactor: 0.65,
                    child: TextFormField(
                      initialValue: finalStory,
                      minLines: 4,
                      maxLines: 8,
                      readOnly: true,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        filled: true,
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                    ),
                  )),
              FractionallySizedBox(
                  widthFactor: 0.65,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                            initialValue:
                                "If you don't like the adventure, you can reboot from the beginning",
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: null,
                            readOnly: true,
                            decoration: const InputDecoration(
                                label: Center(child: Text("Reboot the story")),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                filled: true)),
                        TextFormField(
                            initialValue:
                                "If you're satisfied with the journey you can exit",
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: null,
                            readOnly: true,
                            decoration: const InputDecoration(
                                label:
                                    Center(child: Text("End of the journey")),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                filled: true))
                      ])),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                      width: 702,
                      child: Column(children: [
                        SizedBox(
                            width: 351,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  _reboot(adventure);
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: const Text('Reboot the story'))),
                        Visibility(
                            visible: !kIsWeb,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                    width: 351,
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed: !kIsWeb
                                            ? () {
                                                _exit(adventure);
                                              }
                                            : null,
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                        ),
                                        child: const Text(
                                            'Exit the adventure maker'))))),
                      ]))),
              Expanded(
                  child: Align(
                alignment: FractionalOffset.bottomRight,
                child: Tooltip(
                    message: 'Send your story by email',
                    child: IconButton(
                      iconSize: 50,
                      icon: const Icon(Icons.mail),
                      onPressed: () {
                        _mail(adventure, finalStory, context);
                      },
                    )),
              )),
            ])));
  }

  showAlertDialog(BuildContext context, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color.fromARGB(255, 187, 222, 251),
      title: const Text("MAIL"),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _exit(Adventure adventure) {
    _deleteHistory(adventure);
    if (defaultTargetPlatform == TargetPlatform.android) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (!kIsWeb) {
      exit(0);
    }
  }

  void _mail(Adventure adventure, String story, BuildContext context) {
    if (!kIsWeb) {
      Mail mail = Mail(adventure: adventure);
      mail
          .sendMail(story)
          .then((response) => {showAlertDialog(context, response)});
    } else {
      MailWeb mail = MailWeb(adventure: adventure);
      mail
          .sendMailWeb(story)
          .then((response) => {showAlertDialog(context, response)});
    }
  }

  void _reboot(Adventure adventure) {
    _deleteHistory(adventure);
    Navigator.popUntil(
        context, (Route<dynamic> predicate) => predicate.isFirst);
  }

  void _deleteHistory(Adventure adventure) {
    StoryDatabase()
        .createDatabaseSync()
        .then((data) => {StoryDatabase().deleteStory(adventure.uuid)});
  }
}
