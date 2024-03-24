import 'package:hackaton_project/model/stepstory.dart';
import 'package:hackaton_project/engine/iaengine.dart';

class StoryOpenAiService {
  const StoryOpenAiService({required this.api});
  final IaGeneration api;

  Future<StepStory?> getFirstStep() async {
    return api.generateFirstStep();
  }
}
