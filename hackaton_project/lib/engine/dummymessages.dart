import 'package:hackaton_project/engine/dummy/dummy_message.dart';

class DummyMessages {
  DummyMessage messageCreation(String name) {
    DummyMessage first = DummyMessage(story: "", optionOne: "", optionTwo: "");
    first.story =
        'Once upon a time, in a magical land filled with talking animals and friendly monsters, there lived a little zombie named $name. $name was not like the scary zombies you might have heard about; she was a kind and curious zombie who loved exploring the enchanted forest near her home. One day, as $name ventured deeper into the forest, she stumbled upon a mysterious door covered in glowing vines. Without hesitation, she pushed the door open and found herself in a colorful world filled with floating candies and friendly ghosts.';
    first.optionOne =
        '$name decided to follow the candy path, hoping it would lead her to a magical candy castle.';
    first.optionTwo =
        '$name chose to explore the ghostly forest, thinking that the ghosts might have exciting stories to share.';
    return first;
  }

  DummyMessage stepMessages(String name, int nextStep) {
    switch (nextStep) {
      case 1:
        return messageFirstStep(name);
      case 2:
        return messageSecondStep(name);
      case 3:
        return messageThirdStep(name);
      case 4:
        return messageFourthStep(name);
      default:
        return DummyMessage(story: "", optionOne: "", optionTwo: "");
    }
  }

  DummyMessage messageFirstStep(String name) {
    DummyMessage stepOne =
        DummyMessage(story: "", optionOne: "", optionTwo: "");
    stepOne.story =
        'As $name continued her adventure, she encountered a mischievous witch who offered her a magical potion.';
    stepOne.optionOne =
        '$name eagerly drank the potion, transforming her into a super-fast zombie with the ability to fly.';
    stepOne.optionTwo =
        '$name politely declined the potion, not wanting to risk any strange side effects.';
    return stepOne;
  }

  DummyMessage messageSecondStep(String name) {
    DummyMessage stepTwo =
        DummyMessage(story: "", optionOne: "", optionTwo: "");
    stepTwo.story =
        'With her newfound powers (or without them), $name continued her journey and soon reached a sparkling river. There, she met a wise old turtle who offered to guide her to the heart of the enchanted forest.';
    stepTwo.optionOne =
        '$name decided to hop on the turtles back and ride the river to the heart of the forest.';
    stepTwo.optionTwo =
        '$name thanked the turtle but decided to continue exploring on her own, following the rainbow-colored butterflies that danced through the air.';
    return stepTwo;
  }

  DummyMessage messageThirdStep(String name) {
    DummyMessage stepThird =
        DummyMessage(story: "", optionOne: "", optionTwo: "");
    stepThird.story =
        'Eventually, $name reached the heart of the enchanted forest, where a magical fountain stood.';
    stepThird.optionOne =
        '$name decided to hop on the turtles back and ride the river to the heart of the forest.';
    stepThird.optionTwo =
        '$name thanked the turtle but decided to continue exploring on her own, following the rainbow-colored butterflies that danced through the air.';
    return stepThird;
  }

  DummyMessage messageFourthStep(String name) {
    DummyMessage stepFourth =
        DummyMessage(story: "", optionOne: "", optionTwo: "");

    stepFourth.story =
        'As $name made her wish, a brilliant light enveloped the entire forest, and her zombie friends appeared, dancing and celebrating. The animals and monsters joined in, creating a lively and joyful atmosphere.The end! Now, little one, what do you think Zoes next adventure should be?';

    stepFourth.optionOne =
        '$name and her friends organize a grand feast to celebrate their newfound happiness.';

    stepFourth.optionTwo =
        '$name and her friends plan a big party with games and music to share their joy with the entire enchanted land.';

    return stepFourth;
  }
}
