import 'dart:async';
import 'dart:convert';

import 'package:hackaton_project/model/adventure.dart';
import 'package:hackaton_project/model/stepstory.dart';
import 'package:hackaton_project/engine/dummymessages.dart';

import 'package:http/http.dart' as http;

class IaGeneration {
  const IaGeneration({required this.adventure});
  final Adventure adventure;

  Future<StepStory?> generateFirstStep() async {
    var uri = Uri.parse(
        'https://us-central1-aiplatform.googleapis.com/v1/projects/mygeminiproject/locations/us-central1/publishers/google/models/gemini-1.0-pro:streamGenerateContent?alt=sse');

    String story = adventure.choose;
    String actor = adventure.name;

    String message =
        "generate a $story story with $actor as protagonist. Stop on one point and offer two ways to continue the history";

    // ignore: avoid_print
    print("[IAENGINE] root '$message' ");

    String apiKey = "<google cloud key>";

    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "contents": {
            "role": "user",
            "parts": {"text": message},
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
      DummyMessages msg = DummyMessages();
      stepStory.step = msg.messageCreation().story;
      stepStory.optionOne = msg.messageCreation().optionOne;
      stepStory.optionTwo = msg.messageCreation().optionTwo;
    }

    return stepStory;
  }
}
