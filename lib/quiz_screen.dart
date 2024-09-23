import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, Object>> questions = [
    {
      "question": "Which letter starts with Apple?",
      "options": ["A", "B", "C", "D"],
      "correctAnswer": "A"
    },
    {
      "question": "What color is the sky?",
      "options": ["Red", "Blue", "Green", "Yellow"],
      "correctAnswer": "Blue"
    },
    {
      "question": "Which word means 'أنا'?",
      "options": ["I", "We", "You", "They"],
      "correctAnswer": "I"
    },
  ];

  int currentIndex = 0; // الفهرس الحالي للسؤال
  String feedback = ""; // ملاحظات حول الإجابة

  // التحقق من صحة الإجابة
  void _checkAnswer(String selectedOption) {
    Object? correctAnswer = questions[currentIndex]['correctAnswer'];
    setState(() {
      if (selectedOption == correctAnswer) {
        feedback = "أحسنت! الإجابة صحيحة.";
      } else {
        feedback = "حاول مرة أخرى، الإجابة الصحيحة هي: $correctAnswer";
      }
    });
  }

  // الانتقال إلى السؤال التالي
  void _nextQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % questions.length; // الانتقال بين الأسئلة
      feedback = ""; // إعادة ضبط ملاحظات الإجابة
    });
  }

  @override
  Widget build(BuildContext context) {
    String? question = questions[currentIndex]['question'] as String?;
    List<String>? options = questions[currentIndex]['options'] as List<String>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('تمارين التعليم'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // عرض السؤال
            Text(
              question!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // عرض الخيارات
            ...options!.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  child: Text(
                    option,
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            // عرض ملاحظات حول الإجابة
            Text(
              feedback,
              style: TextStyle(fontSize: 22, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // زر للانتقال إلى السؤال التالي
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(
                'السؤال التالي',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
