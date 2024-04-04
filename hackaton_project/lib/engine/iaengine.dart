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

  Future<StepStory?> generateNextStep(
      String optionChoosen, int nextStep) async {
    String url = "";
    String apiKey = "";
    String nextMessage = "";

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

    StepStory stepStory =
        StepStory(code: "", step: "", optionOne: "", optionTwo: "");

    String codeHttp = response.statusCode.toString();
    // ignore: avoid_print
    print("[IAENGINE] code $codeHttp");

    if (response.statusCode == 200) {
      var body = response.body;
      body = body.substring("data :".length);
      stepStory.code = response.statusCode.toString();
    } else {
      stepStory.code = "999";
      DummyMessages msgEng = DummyMessages();
      DummyMessage msg =
          msgEng.stepMessages(adventure.name.toUpperCase(), nextStep);
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

    StepStory stepStory =
        StepStory(code: "", step: "", optionOne: "", optionTwo: "");

    String codeHttp = response.statusCode.toString();
    // ignore: avoid_print
    print("[IAENGINE] code $codeHttp");

    if (response.statusCode == 200) {
      var body = response.body;
      body = body.substring("data :".length);
      stepStory.code = response.statusCode.toString();
    } else {
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
