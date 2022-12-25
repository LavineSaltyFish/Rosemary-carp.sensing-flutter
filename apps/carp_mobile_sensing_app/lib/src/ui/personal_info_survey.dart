part of mobile_sensing_app;

//
// // class _PersonalInfoSurvey implements Survey {
// //   @override
// //   String get title => "PersonalInfo";
// //
// //   @override
// //   String get description => "Questions about you...";
// //
// //   @override
// //   int get minutesToComplete => 3;
// // }
// // class PersonalSurvey {
// //
// //   onstart() {
// //     return RPUITask(
// //         task: personalSurveyTask,
// //         onSubmit: (result) {
// //           print(result);
// //         },
// //         onCancel: (RPTaskResult? result) {
// //           if (result == null) {
// //             print("No result");
// //           } else
// //             print(result);
// //         });
// //   }
// // }
//
class PersonalInfoSurvey extends StatelessWidget {
  const PersonalInfoSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    return RPUITask(
      task: personalSurveyTask,
      onSubmit: (RPTaskResult result) {
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
        if (result == null) {
          print("No result");
        } else
          print(result);

        Navigator.pop(context);
      },

    );
  }

  static ValueNotifier<String> _age = ValueNotifier<String>("");
  static ValueNotifier<String> _height = ValueNotifier<String>("");
  static ValueNotifier<String> _weight = ValueNotifier<String>("");
  static ValueNotifier<String> _gender = ValueNotifier<String>("");

  void resultCallback(RPTaskResult result) {
    // Do anything with the result
    print(result.identifier);
  }
}

RPFormStep formStep = RPFormStep(
  identifier: "formstepID",
  steps: [
    genderQuestionStep,
    ageQuestionStep,
    heightQuestionStep,
    weightQuestionStep,
    physicalLevelQuestionStep,
    exerciseMinutesQuestionStep
  ],
  title: "Questions about you...",
);

RPOrderedTask personalSurveyTask = RPOrderedTask(
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

// question 1, gender
RPQuestionStep genderQuestionStep = RPQuestionStep(
    identifier: "genderQuestionStepID",
    title: "What is your gender?",
    answerFormat: genderAnswerFormat);

List<RPChoice> genderChoices = [
  RPChoice(text: "Male", value: 1),
  RPChoice(text: "Female", value: 0)
];

RPChoiceAnswerFormat genderAnswerFormat = RPChoiceAnswerFormat(
  answerStyle: RPChoiceAnswerStyle.SingleChoice,
  choices: genderChoices,
);

// question 2, age
RPQuestionStep ageQuestionStep = RPQuestionStep(
    identifier: "ageQuestionStepID",
    title: "What is your age?",
    answerFormat: ageAnswerFormat);

RPIntegerAnswerFormat ageAnswerFormat =
    RPIntegerAnswerFormat(minValue: 0, maxValue: 100, suffix: "");

// question 3, height
RPQuestionStep heightQuestionStep = RPQuestionStep(
    identifier: "heightQuestionStepID",
    title: "What is your height?",
    answerFormat: heightAnswerFormat);

RPIntegerAnswerFormat heightAnswerFormat =
    RPIntegerAnswerFormat(minValue: 0, maxValue: 210, suffix: "CM");

// question 4, weight
RPQuestionStep weightQuestionStep = RPQuestionStep(
    identifier: "weightQuestionStepID",
    title: "What is your weight?",
    answerFormat: weightAnswerFormat);

RPIntegerAnswerFormat weightAnswerFormat =
    RPIntegerAnswerFormat(minValue: 0, maxValue: 200, suffix: "KG");

// question 5, physical level
RPQuestionStep physicalLevelQuestionStep = RPQuestionStep(
    identifier: "physicalLevelQuestionStepID",
    title:
        "Would you say that you are physically more active, less active or about as active as other persons your age?",
    answerFormat: physicalLevelAnswerFormat);

RPChoiceAnswerFormat physicalLevelAnswerFormat = RPChoiceAnswerFormat(
  answerStyle: RPChoiceAnswerStyle.SingleChoice,
  choices: physicalLevelChoices,
);
List<RPChoice> physicalLevelChoices = [
  RPChoice(text: "More", value: 1),
  RPChoice(text: "Less", value: -1),
  RPChoice(text: "Same", value: -0),
];

// question 6, exercise time per week
RPQuestionStep exerciseMinutesQuestionStep = RPQuestionStep(
    identifier: "exerciseMinutesQuestionStepID",
    title: "On average, how many minutes do you exercise per week?",
    answerFormat: exerciseMinutesAnswerFormat);

RPIntegerAnswerFormat exerciseMinutesAnswerFormat =
    RPIntegerAnswerFormat(minValue: 0, maxValue: 1000, suffix: "Minute");
