import 'package:ChatGpt/components/answers.dart';
import 'package:ChatGpt/components/questions.dart';
import 'package:flutter/material.dart';

class AnswersQuestions extends StatelessWidget {
  List<Map<String, String>> allData = [];

  AnswersQuestions({required this.allData, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        allData.length,
        (index) => Column(
          children: [
            Questions(allData: allData, index: index),
            Answers(allData: allData, index: index)
          ],
        ),
      ),
    );
  }
}
