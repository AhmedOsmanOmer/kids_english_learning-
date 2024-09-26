import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, Object>> questions = [
    {
      "question": "What comes after 7?",
      "options": ["6", "8", "9", "10"],
      "correctAnswer": "8"
    },
    {
      "question": "How many legs does a dog have?",
      "options": ["2", "3", "4", "5"],
      "correctAnswer": "4"
    },
    {
      "question": "What is 10 + 5?",
      "options": ["12", "14", "15", "16"],
      "correctAnswer": "15"
    },

    // تمارين على الألوان
    {
      "question": "What color is the sky?",
      "options": ["Red", "Blue", "Green", "Yellow"],
      "correctAnswer": "Blue"
    },
    {
      "question": "Which color is a banana?",
      "options": ["Red", "Green", "Yellow", "Blue"],
      "correctAnswer": "Yellow"
    },
    {
      "question": "What color is an apple?",
      "options": ["Red", "Pink", "Black", "Yellow"],
      "correctAnswer": "Red"
    },

    // تمارين على الحيوانات
    {
      "question": "Which animal says 'Meow'?",
      "options": ["Dog", "Cat", "Cow", "Lion"],
      "correctAnswer": "Cat"
    },
    {
      "question": "Which animal is known as the king of the jungle?",
      "options": ["Lion", "Elephant", "Tiger", "Zebra"],
      "correctAnswer": "Lion"
    },
    {
      "question": "Which animal can fly?",
      "options": ["Bird", "Fish", "Tiger", "Elephant"],
      "correctAnswer": "Bird"
    },

    // تمارين على الأفعال
    {
      "question": "What do you do with a book?",
      "options": ["Run", "Sleep", "Read", "Swim"],
      "correctAnswer": "Read"
    },
    {
      "question": "What do you do with food?",
      "options": ["Eat", "Jump", "Sleep", "Play"],
      "correctAnswer": "Eat"
    },
    {
      "question": "What do you do when you are tired?",
      "options": ["Dance", "Sleep", "Play", "Eat"],
      "correctAnswer": "Sleep"
    }
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
      currentIndex =
          (currentIndex + 1) % questions.length; // الانتقال بين الأسئلة
      feedback = ""; // إعادة ضبط ملاحظات الإجابة
    });
  }

  @override
  Widget build(BuildContext context) {
    String? question = questions[currentIndex]['question'] as String?;
    List<String>? options = questions[currentIndex]['options'] as List<String>?;

    return Scaffold(
      backgroundColor: Colors.white,
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
