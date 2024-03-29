import 'package:hackaton_project/engine/dummy/dummy_message.dart';

class DummyMessages {
  DummyMessage messageCreation() {
    DummyMessage first = DummyMessage(story: "", optionOne: "", optionTwo: "");
    first.story =
        'Once upon a time, in a magical land filled with talking animals and friendly monsters, there lived a little zombie named Zoe. Zoe was not like the scary zombies you might have heard about; she was a kind and curious zombie who loved exploring the enchanted forest near her home. One day, as Zoe ventured deeper into the forest, she stumbled upon a mysterious door covered in glowing vines. Without hesitation, she pushed the door open and found herself in a colorful world filled with floating candies and friendly ghosts.';
    first.optionOne =
        'Zoe decided to follow the candy path, hoping it would lead her to a magical candy castle.';
    first.optionTwo =
        'Zoe chose to explore the ghostly forest, thinking that the ghosts might have exciting stories to share.';
    return first;
  }
}
