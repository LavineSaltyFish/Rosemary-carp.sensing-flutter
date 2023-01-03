part of mobile_sensing_app;

class PersonalInfoSurvey extends StatelessWidget {
  const PersonalInfoSurvey({super.key});
  //static RPTaskResult? surveyResult;
  @override
  Widget build(BuildContext context) {
    return RPUITask(
      task: SurveyComponents().personalSurveyTask,
      onSubmit: (RPTaskResult result) {
        //surveyResult = result;

        _age.value = result.results['ageQuestionStepID']?.toJson()["results"]
            ["answer"] as String;
        _height.value = result.results['heightQuestionStepID']
            ?.toJson()["results"]["answer"] as String;
        _weight.value = result.results['weightQuestionStepID']
            ?.toJson()["results"]["answer"] as String;
        _gender.value = (result.results['genderQuestionStepID']
                ?.toJson()["results"]["answer"][0] as RPChoice)
            .text;

        Navigator.pop(context);
      },
      onCancel: (RPTaskResult? result) {

      },
    );
  }

  static ValueNotifier<String> _age = ValueNotifier<String>("-");
  static ValueNotifier<String> _height = ValueNotifier<String>("-");
  static ValueNotifier<String> _weight = ValueNotifier<String>("-");
  static ValueNotifier<String> _gender = ValueNotifier<String>("-");


}

class SurveyComponents {

  RPOrderedTask personalSurveyTask =
      RPOrderedTask(identifier: "personalInfoSurveyTaskID", steps: []);

  SurveyComponents() {

    List<RPChoice> genderChoices = [
      RPChoice(text: "Male", value: 1),
      RPChoice(text: "Female", value: 0)
    ];

    List<RPChoice> physicalLevelChoices = [
      RPChoice(text: "More", value: 1),
      RPChoice(text: "Less", value: -1),
      RPChoice(text: "Same", value: -0),
    ];

    RPQuestionStep ageQuestionStep = buildIntegerStep(
        'ageQuestionStepID',
        'What is your age?',
        RPIntegerAnswerFormat(minValue: 0, maxValue: 100, suffix: ""));

    RPQuestionStep genderQuestionStep = buildChoiceStep(
        'genderQuestionStepID',
        "What is your gender?",
        RPChoiceAnswerFormat(
          answerStyle: RPChoiceAnswerStyle.SingleChoice,
          choices: genderChoices,
        ));

    RPQuestionStep heightQuestionStep = buildIntegerStep(
        'heightQuestionStepID',
        'What is your height?',
        RPIntegerAnswerFormat(minValue: 0, maxValue: 210, suffix: "CM"));

    RPQuestionStep weightQuestionStep = buildIntegerStep(
        'weightQuestionStepID',
        'What is your weight?',
        RPIntegerAnswerFormat(minValue: 0, maxValue: 200, suffix: "KG"));

    RPQuestionStep physicalLevelQuestionStep = buildChoiceStep(
        'physicalLevelQuestionStepID',
        "Would you say that you are physically more active, less active or about as active as other persons your age?",
        RPChoiceAnswerFormat(
          answerStyle: RPChoiceAnswerStyle.SingleChoice,
          choices: physicalLevelChoices,
        ));

    RPQuestionStep exerciseMinutesQuestionStep = buildIntegerStep(
        'exerciseMinutesQuestionStepID',
        "On average, how many minutes do you exercise per week?",
        RPIntegerAnswerFormat(minValue: 0, maxValue: 1000, suffix: "Min"));

    this.personalSurveyTask = RPOrderedTask(
        closeAfterFinished: false,
        identifier: "personalInfoSurveyTaskID",
        steps: [
          genderQuestionStep,
          ageQuestionStep,
          heightQuestionStep,
          weightQuestionStep,
          physicalLevelQuestionStep,
          exerciseMinutesQuestionStep
        ] //[formStep],
        );
  }

  RPQuestionStep buildIntegerStep(
      String id, String title, RPIntegerAnswerFormat answerFormat) {
    return RPQuestionStep(
        identifier: id, title: title, answerFormat: answerFormat);
  }

  RPQuestionStep buildChoiceStep(
      String id, String title, RPChoiceAnswerFormat answerFormat) {
    return RPQuestionStep(
        identifier: id, title: title, answerFormat: answerFormat);
  }
}

// // question 1, gender
//   RPQuestionStep genderQuestionStep = RPQuestionStep(
//       identifier: "genderQuestionStepID",
//       title: "What is your gender?",
//       answerFormat: genderAnswerFormat);
//
//   List<RPChoice> genderChoices = [
//     RPChoice(text: "Male", value: 1),
//     RPChoice(text: "Female", value: 0)
//   ];
//
//   RPChoiceAnswerFormat genderAnswerFormat = RPChoiceAnswerFormat(
//     answerStyle: RPChoiceAnswerStyle.SingleChoice,
//     choices: genderChoices,
//   );

// RPFormStep formStep = RPFormStep(
//   identifier: "formstepID",
//   steps: [
//     genderQuestionStep,
//     ageQuestionStep,
//     heightQuestionStep,
//     weightQuestionStep,
//     physicalLevelQuestionStep,
//     exerciseMinutesQuestionStep
//   ],
//   title: "Questions about you...",
// );

// // question 2, age
//   RPQuestionStep ageQuestionStep = RPQuestionStep(
//       identifier: "ageQuestionStepID",
//       title: "What is your age?",
//       answerFormat: ageAnswerFormat);
//
//   RPIntegerAnswerFormat ageAnswerFormat =
//   RPIntegerAnswerFormat(minValue: 0, maxValue: 100, suffix: "");

// // question 3, height
//   RPQuestionStep heightQuestionStep = RPQuestionStep(
//       identifier: "heightQuestionStepID",
//       title: "What is your height?",
//       answerFormat: heightAnswerFormat);
//
//   RPIntegerAnswerFormat heightAnswerFormat =
//   RPIntegerAnswerFormat(minValue: 0, maxValue: 210, suffix: "CM");

// // question 4, weight
//   RPQuestionStep weightQuestionStep = RPQuestionStep(
//       identifier: "weightQuestionStepID",
//       title: "What is your weight?",
//       answerFormat: weightAnswerFormat);
//
//   RPIntegerAnswerFormat weightAnswerFormat =
//   RPIntegerAnswerFormat(minValue: 0, maxValue: 200, suffix: "KG");
//
// // question 5, physical level
//   RPQuestionStep physicalLevelQuestionStep = RPQuestionStep(
//       identifier: "physicalLevelQuestionStepID",
//       title:
//       "Would you say that you are physically more active, less active or about as active as other persons your age?",
//       answerFormat: physicalLevelAnswerFormat);
//
//   RPChoiceAnswerFormat physicalLevelAnswerFormat = RPChoiceAnswerFormat(
//     answerStyle: RPChoiceAnswerStyle.SingleChoice,
//     choices: physicalLevelChoices,
//   );
//   List<RPChoice> physicalLevelChoices = [
//     RPChoice(text: "More", value: 1),
//     RPChoice(text: "Less", value: -1),
//     RPChoice(text: "Same", value: -0),
//   ];

// // question 6, exercise time per week
//   RPQuestionStep exerciseMinutesQuestionStep = RPQuestionStep(
//       identifier: "exerciseMinutesQuestionStepID",
//       title: "On average, how many minutes do you exercise per week?",
//       answerFormat: exerciseMinutesAnswerFormat);
//
//   RPIntegerAnswerFormat exerciseMinutesAnswerFormat =
//   RPIntegerAnswerFormat(minValue: 0, maxValue: 1000, suffix: "Minute");
