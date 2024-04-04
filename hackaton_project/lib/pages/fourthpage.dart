import 'package:flutter/material.dart';
import 'package:hackaton_project/model/adventure.dart';
import 'package:hackaton_project/model/stepstory.dart';
import 'package:hackaton_project/engine/iaengine.dart';
import 'package:hackaton_project/engine/iaengineservice.dart';
import 'package:hackaton_project/model/story.dart';
import 'package:hackaton_project/db/storydatabase.dart';
import 'package:sprintf/sprintf.dart';
import 'package:hackaton_project/pages/finalpage.dart';

//https://stackoverflow.com/questions/43122113/sizing-elements-to-percentage-of-screen-width-height
class FourthPage extends StatelessWidget {
  const FourthPage(
      {super.key,
      required this.title,
      required this.adventure,
      required this.stepStory,
      required this.step});
  final String title;
  final Adventure adventure;
  final StepStory stepStory;
  final int step;

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
        body: FourthPageForm(
            adventure: adventure, stepStory: stepStory, step: step));
  }
}

class FourthPageForm extends StatefulWidget {
  const FourthPageForm(
      {super.key,
      required this.adventure,
      required this.stepStory,
      required this.step});
  final Adventure adventure;
  final StepStory stepStory;
  final int step;
  @override
  FourthPageFormState createState() {
    // ignore: no_logic_in_create_state
    return FourthPageFormState(
        adventure: adventure, stepStory: stepStory, step: step);
  }
}

class FourthPageFormState extends State<FourthPageForm> {
  FourthPageFormState(
      {required this.adventure, required this.stepStory, required this.step});
  final _formKey = GlobalKey<FormState>();
  final Adventure adventure;
  final StepStory stepStory;
  final int step;

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
                      initialValue: stepStory.step,
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
                            initialValue: stepStory.optionOne,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: null,
                            readOnly: true,
                            decoration: const InputDecoration(
                                label: Center(child: Text("First Option")),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                filled: true)),
                        TextFormField(
                            initialValue: stepStory.optionTwo,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: null,
                            readOnly: true,
                            decoration: const InputDecoration(
                                label: Center(child: Text("Second Option")),
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                filled: true))
                      ])),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                      width: 702,
                      child: Row(children: [
                        SizedBox(
                            width: 234,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  _updateProcess(stepStory.optionOne);
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: const Text('Choose Option One'))),
                        SizedBox(
                            width: 234,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  _updateProcess(stepStory.optionTwo);
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: const Text('Choose Option Two'))),
                        SizedBox(
                            width: 234,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  _processAllStory(adventure.uuid);
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: const Text('End of the Journey')))
                      ])))
            ])));
  }

  void _updateProcess(String option) {
    IaGeneration ia = IaGeneration(adventure: adventure);
    StoryOpenAiService storyIa = StoryOpenAiService(api: ia);

    int nextStep = step + 1;

    storyIa.getNextStep(option, nextStep).then((data) {
      if ((data?.code == "200") || (data?.code == "999")) {
        if (data!.step != "") {
          String stepType = sprintf("Step-%s", [step.toString()]);

          Story story = Story(
              id: step,
              uuid: adventure.uuid,
              stepType: stepType,
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
                step: nextStep);
          }));
        } else {
          _processAllStory(adventure.uuid);
        }
      }
    });
  }

  void _final(String totalStory) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FinalPage(
          title:
              'Build your own adventure - END of your journey ${adventure.name.toUpperCase()}',
          adventure: adventure,
          finalStory: totalStory);
    }));
  }

  void _processAllStory(String uuid) {
    StoryDatabase().createDatabaseSync().then((data) => {
          data.storyList(uuid).then((result) => {_final(result)})
        });
  }
}
