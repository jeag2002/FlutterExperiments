import 'dart:async';
import 'dart:convert';

import 'package:hackaton_project/engine/dummy/dummy_message.dart';
import 'package:hackaton_project/model/adventure.dart';
import 'package:hackaton_project/model/stepstory.dart';
import 'package:hackaton_project/engine/dummymessages.dart';
import 'package:hackaton_project/properties/properties.dart';
import 'package:sprintf/sprintf.dart';

import 'package:http/http.dart' as http;

class IaGeneration {
  const IaGeneration({required this.adventure});
  final Adventure adventure;

  Future<StepStory?> generateFinalStep() async {
    String url = "";
    String apiKey = "";
    String finalMessage = "";

    PropertyFile file = await PropertyFile().loadPropertyFileSync();

    url = file.getAttribute("url");
    apiKey = file.getAttribute("api-key");
    finalMessage = file.getAttribute("final-message");

    // ignore: avoid_print
    print("[IAENGINE] ---- CALL FINAL STEP");

    var uri = Uri.parse(url);

    // ignore: avoid_print
    print("[IAENGINE] url $url");
    // ignore: avoid_print
    print("[IAENGINE] nextMessage $finalMessage");

    String apiKey_1 = apiKey;

    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey_1',
        },
        body: jsonEncode({
          "contents": {
            "role": "user",
            "parts": {"text": finalMessage},
          },
          "safety_settings": {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_LOW_AND_ABOVE"
          },
          "generation_config": {"temperature": 0.2, "topP": 0.8, "topK": 40}
        }));

    StepStory stepStory =
        StepStory(code: "", step: "", optionOne: "", optionTwo: "");

    String codeHttp = response.statusCode.toString();
    // ignore: avoid_print
    print("[IAENGINE] code $codeHttp");

    if (response.statusCode == 200) {
      var body = response.body;
      // ignore: avoid_print
      //print("body: $body");
      stepStory.code = response.statusCode.toString();

      body = body.replaceAll('data:', '');
      // ignore: avoid_print
      //print("body: $body");

      String storyTell = "";

      RegExp regExp = RegExp('{\\"text\\":(\\s)"([^\\n\\r]*)\\"}');

      Iterable<RegExpMatch> matches = regExp.allMatches(body);
      for (var element in matches) {
        storyTell = storyTell + element.group(2)!;
      }
      storyTell = storyTell.replaceAll('\\n', "\n");
      storyTell = storyTell.replaceAll('**', "");

      // ignore: avoid_print
      print("storyTell: $storyTell");

      stepStory.step = storyTell;
      stepStory.optionOne = "";
      stepStory.optionTwo = "";
    } else {
      stepStory.code = "999";
      DummyMessages msgEng = DummyMessages();
      DummyMessage msg = msgEng.messageFinal(adventure.name.toUpperCase());
      stepStory.step = msg.story;
      stepStory.optionOne = msg.optionOne;
      stepStory.optionTwo = msg.optionTwo;
    }

    // ignore: avoid_print
    print("[IAENGINE] ---- CALL FINAL");

    return stepStory;
  }

  Future<StepStory?> generateNextStep(
      String optionChoosen, int nextStep) async {
    String url = "";
    String apiKey = "";
    String nextMessage = "";

    String optionONE = "Option One:";
    String optionTWO = "Option Two:";

    StepStory stepStory =
        StepStory(code: "", step: "", optionOne: "", optionTwo: "");

    try {
      PropertyFile file = await PropertyFile().loadPropertyFileSync();

      url = file.getAttribute("url");
      apiKey = file.getAttribute("api-key");
      nextMessage = file.getAttribute("next-message");

      // ignore: avoid_print
      print("[IAENGINE] ---- CALL STEP $nextStep");

      var uri = Uri.parse(url);
      nextMessage = sprintf(nextMessage, [optionChoosen]);

      // ignore: avoid_print
      print("[IAENGINE] url $url");
      // ignore: avoid_print
      print("[IAENGINE] nextMessage $nextMessage");

      String apiKey_1 = apiKey;

      var response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey_1',
          },
          body: jsonEncode({
            "contents": {
              "role": "user",
              "parts": {"text": nextMessage},
            },
            "safety_settings": {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_LOW_AND_ABOVE"
            },
            "generation_config": {"temperature": 0.2, "topP": 0.8, "topK": 40}
          }));

      String codeHttp = response.statusCode.toString();
      // ignore: avoid_print
      print("[IAENGINE] code $codeHttp");

      if (response.statusCode == 200) {
        var body = response.body;
        stepStory.code = response.statusCode.toString();

        body = body.replaceAll('data:', '');
        // ignore: avoid_print
        //print("body: $body");

        String storyTell = "";

        RegExp regExp = RegExp('{\\"text\\":(\\s)"([^\\n\\r]*)\\"}');

        Iterable<RegExpMatch> matches = regExp.allMatches(body);
        for (var element in matches) {
          storyTell = storyTell + element.group(2)!;
        }
        storyTell = storyTell.replaceAll('\\n', "\n");
        storyTell = storyTell.replaceAll('**', "");

        // ignore: avoid_print
        print("storyTell: $storyTell");

        String stepStoryTell = "";
        String stepStoryOptionOne = "";
        String stepStoryOptionTwo = "";

        if (storyTell.contains(optionONE)) {
          stepStoryTell = storyTell.substring(0, storyTell.indexOf(optionONE));
        } else {
          stepStoryTell = storyTell;
        }

        if (storyTell.contains(optionONE) && storyTell.contains(optionTWO)) {
          stepStoryOptionOne = storyTell.substring(
              storyTell.indexOf(optionONE) + optionONE.length,
              storyTell.indexOf(optionTWO));
        } else {
          stepStoryOptionOne = storyTell.substring(
              storyTell.indexOf(optionONE) + optionONE.length,
              storyTell.length);
        }

        if (storyTell.contains(optionTWO)) {
          stepStoryOptionTwo = storyTell
              .substring(storyTell.indexOf(optionTWO) + optionTWO.length);
        }

        stepStory.step = stepStoryTell.trim();
        stepStory.optionOne = stepStoryOptionOne.trim();
        stepStory.optionTwo = stepStoryOptionTwo.trim();
      } else {
        stepStory.code = "999";
        DummyMessages msgEng = DummyMessages();
        DummyMessage msg =
            msgEng.stepMessages(adventure.name.toUpperCase(), nextStep);
        stepStory.step = msg.story;
        stepStory.optionOne = msg.optionOne;
        stepStory.optionTwo = msg.optionTwo;
      }
    } catch (e) {
      // ignore: avoid_print
      print("[IAENGINE] ----ROOT CALL ERROR $e");

      stepStory = StepStory(code: "", step: "", optionOne: "", optionTwo: "");

      stepStory.code = "999";

      DummyMessages msgEng = DummyMessages();
      DummyMessage msg = msgEng.messageCreation(adventure.name.toUpperCase());
      stepStory.step = msg.story;
      stepStory.optionOne = msg.optionOne;
      stepStory.optionTwo = msg.optionTwo;
    }

    // ignore: avoid_print
    print("[IAENGINE] ---- CALL STEP $nextStep");

    return stepStory;
  }

  Future<StepStory?> generateFirstStep() async {
    String url = "";
    String apiKey = "";
    String firstMessage = "";

    String optionONE = "Option One:";
    String optionTWO = "Option Two:";

    StepStory stepStory =
        StepStory(code: "", step: "", optionOne: "", optionTwo: "");

    try {
      PropertyFile file = await PropertyFile().loadPropertyFileSync();

      url = file.getAttribute("url");
      apiKey = file.getAttribute("api-key");
      firstMessage = file.getAttribute("first-message");

      var uri = Uri.parse(url);

      String story = adventure.choose;
      String actor = adventure.name;

      String message_1 = sprintf(firstMessage, [story, actor]);

      // ignore: avoid_print
      print("[IAENGINE] ----ROOT CALL");
      // ignore: avoid_print
      print("[IAENGINE] url $url");
      // ignore: avoid_print
      print("[IAENGINE] nextMessage $message_1");

      String apiKey_1 = apiKey;

      var response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey_1',
          },
          body: jsonEncode({
            "contents": {
              "role": "user",
              "parts": {"text": message_1},
            },
            "safety_settings": {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_LOW_AND_ABOVE"
            },
            "generation_config": {"temperature": 0.2, "topP": 0.8, "topK": 40}
          }));

      String codeHttp = response.statusCode.toString();
      // ignore: avoid_print
      print("[IAENGINE] code $codeHttp");

      String storyTell = "";

      if (response.statusCode == 200) {
        stepStory.code = response.statusCode.toString();
        var body = response.body;
        body = body.replaceAll('data:', '');
        // ignore: avoid_print
        //print("body: $body");

        RegExp regExp = RegExp('{\\"text\\":(\\s)"([^\\n\\r]*)\\"}');

        Iterable<RegExpMatch> matches = regExp.allMatches(body);
        for (var element in matches) {
          storyTell = storyTell + element.group(2)!;
        }
        storyTell = storyTell.replaceAll('\\n', "\n");
        storyTell = storyTell.replaceAll('**', "");
        storyTell = storyTell.replaceAll("\\\"", '\\"');

        // ignore: avoid_print
        print("storyTell: $storyTell");

        String stepStoryTell = "";
        String stepStoryOptionOne = "";
        String stepStoryOptionTwo = "";

        if (storyTell.contains(optionONE)) {
          stepStoryTell = storyTell.substring(0, storyTell.indexOf(optionONE));
        } else {
          stepStoryTell = storyTell;
        }

        if (storyTell.contains(optionONE) && storyTell.contains(optionTWO)) {
          stepStoryOptionOne = storyTell.substring(
              storyTell.indexOf(optionONE) + optionONE.length,
              storyTell.indexOf(optionTWO));
        } else {
          stepStoryOptionOne = storyTell.substring(
              storyTell.indexOf(optionONE) + optionONE.length,
              storyTell.length);
        }

        if (storyTell.contains(optionTWO)) {
          stepStoryOptionTwo = storyTell
              .substring(storyTell.indexOf(optionTWO) + optionTWO.length);
        }

        stepStory.step = stepStoryTell.trim();
        stepStory.optionOne = stepStoryOptionOne.trim();
        stepStory.optionTwo = stepStoryOptionTwo.trim();
      } else {
        stepStory.code = "999";

        DummyMessages msgEng = DummyMessages();
        DummyMessage msg = msgEng.messageCreation(adventure.name.toUpperCase());
        stepStory.step = msg.story;
        stepStory.optionOne = msg.optionOne;
        stepStory.optionTwo = msg.optionTwo;
      }
    } catch (e) {
      // ignore: avoid_print
      print("[IAENGINE] ----ROOT CALL ERROR $e");

      stepStory = StepStory(code: "", step: "", optionOne: "", optionTwo: "");

      stepStory.code = "999";

      DummyMessages msgEng = DummyMessages();
      DummyMessage msg = msgEng.messageCreation(adventure.name.toUpperCase());
      stepStory.step = msg.story;
      stepStory.optionOne = msg.optionOne;
      stepStory.optionTwo = msg.optionTwo;
    }

    // ignore: avoid_print
    print("[IAENGINE] ----ROOT CALL");

    return stepStory;
  }
}
