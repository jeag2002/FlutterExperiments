import 'package:flutter/material.dart';
import 'package:hackaton_project/model/adventure.dart';
import 'package:hackaton_project/model/story.dart';
import 'package:hackaton_project/engine/iaengine.dart';
import 'package:hackaton_project/db/storydatabase.dart';
import 'package:hackaton_project/engine/iaengineservice.dart';
import 'package:hackaton_project/pages/fourthpage.dart';

//https://docs.flutter.dev/cookbook/animation/page-route-animation

class TercerPage extends StatelessWidget {
  const TercerPage({super.key, required this.title, required this.form});
  final String title;
  final Adventure form;

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
        body: TercerPageForm(adventure: form));
  }
}

// Create a Form widget.
class TercerPageForm extends StatefulWidget {
  const TercerPageForm({super.key, required this.adventure});
  final Adventure adventure;

  @override
  TercerPageFormState createState() {
    // ignore: no_logic_in_create_state
    return TercerPageFormState(adventure: adventure);
  }
}

class TercerPageFormState extends State<TercerPageForm>
    with TickerProviderStateMixin {
  TercerPageFormState({required this.adventure});
  final Adventure adventure;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
    _updateProcess();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SizedBox(width: 500, height: 10, child: LinearProgressIndicator()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Processing Story...",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]));
  }

  void _updateProcess() {
    String uuid = adventure.uuid;
    String story = adventure.choose;
    String protagonist = adventure.name;

    // ignore: avoid_print
    print(
        "[PROCESS] generating story $uuid type: $story protagonist: $protagonist");

    IaGeneration ia = IaGeneration(adventure: adventure);
    StoryOpenAiService storyIa = StoryOpenAiService(api: ia);

    storyIa.getFirstStep().then((data) {
      if ((data?.code == "200") || (data?.code == "999")) {
        if (data!.step != "") {
          Story story = Story(
              id: 0,
              uuid: adventure.uuid,
              stepType: "first",
              step: data.step,
              optionOne: data.optionOne,
              optionTwo: data.optionTwo);

          StoryDatabase()
              .createDatabaseSync()
              .then((response) => {StoryDatabase().insertStory(story)});

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FourthPage(
                title:
                    'Build your own adventure - Step of your journey ${adventure.name.toUpperCase()}',
                adventure: adventure,
                stepStory: data,
                step: 1);
          }));
        }
      }
    });
  }
}
