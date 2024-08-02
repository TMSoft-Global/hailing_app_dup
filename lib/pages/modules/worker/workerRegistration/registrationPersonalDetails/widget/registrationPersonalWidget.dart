import 'package:flutter/material.dart';
import 'package:progress_bar_steppers/steppers.dart';

Widget registrationPersonalWidget({
  required Widget child,
  required int currentStep,
}) {
  return Stack(
    children: [
      Steppers(
        direction: StepperDirection.horizontal,
        labels: [
          StepperData(label: 'Personal'),
          StepperData(label: 'ID Details'),
          StepperData(label: 'Vehicle Info'),
        ],
        currentStep: currentStep,
        stepBarStyle: StepperStyle(maxLineLabel: 3),
      ),
      Container(
        margin: const EdgeInsets.only(top: 60),
        child: child,
      ),
    ],
  );
}
