class Story {
  final int id;
  final String uuid;
  final String stepType;
  final String step;
  final String optionOne;
  final String optionTwo;

  const Story(
      {required this.id,
      required this.uuid,
      required this.stepType,
      required this.step,
      required this.optionOne,
      required this.optionTwo});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'stepType': stepType,
      'step': step,
      'optionOne': optionOne,
      'optionTwo': optionTwo
    };
  }
}
