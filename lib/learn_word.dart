import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // مكتبة لتحويل النص إلى كلام
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // مكتبة لتحويل الكلام إلى نص

class WordLearningScreen extends StatefulWidget {
  const WordLearningScreen({super.key});

  @override
  _WordLearningScreenState createState() => _WordLearningScreenState();
}

class _WordLearningScreenState extends State<WordLearningScreen>
    with SingleTickerProviderStateMixin {
  FlutterTts? flutterTts; // تحويل النص إلى كلام
  stt.SpeechToText? speechToText; // تحويل الكلام إلى نص
  bool isListening = false;
  String feedback = ""; // ملاحظات تصحيح النطق
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  List<Map<String, String>> words = [
    // أشياء
    {"word": "Chair", "image": "assets/chair.jpg"},
    {"word": "Table", "image": "assets/table.jpg"},
    {"word": "Pencil", "image": "assets/pencil.jpg"},
    {"word": "Book", "image": "assets/book.jpg"},
    {"word": "Bottle", "image": "assets/bottle.jpg"},

    // حيوانات
    {"word": "Lion", "image": "assets/lion.png"},
    {"word": "Bird", "image": "assets/bird.jpg"},
    {"word": "Horse", "image": "assets/horse.jpg"},
    {"word": "Monkey", "image": "assets/monkey.jpg"},
    {"word": "Tiger", "image": "assets/tiger.jpg"},

    // أفعال
    {"word": "Run", "image": "assets/run.jpg"},
    {"word": "Jump", "image": "assets/jump.jpg"},
    {"word": "Eat", "image": "assets/eat.jpg"},
    {"word": "Sleep", "image": "assets/sleep.jpg"},
    {"word": "Drink", "image": "assets/drink.jpg"},

    // فاكهة
    {"word": "Banana", "image": "assets/banana.jpg"},
    {"word": "Orange", "image": "assets/orange.jpg"},
    {"word": "Grapes", "image": "assets/grapes.jpg"},
    {"word": "Pineapple", "image": "assets/pineapple.jpg"},
    {"word": "Strawberry", "image": "assets/strawberry.jpg"},

    // أجزاء الجسم
    {"word": "Head", "image": "assets/head.jpg"},
    {"word": "Hand", "image": "assets/hand.jpg"},
    {"word": "Leg", "image": "assets/feets.jpg"},
    {"word": "Eye", "image": "assets/eye.jpg"},
    {"word": "Mouth", "image": "assets/mouth.jpg"},
  ];

  int currentIndex = 0; // الفهرس الحالي للكلمة

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts(); // تهيئة TTS
    speechToText = stt.SpeechToText(); // تهيئة Speech-to-Text

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward(); // بدء الرسوم المتحركة
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // نطق الكلمة باستخدام TTS
  Future<void> _speak(String word) async {
    await flutterTts!.setLanguage("en-US");
    await flutterTts!.setSpeechRate(0.5);
    await flutterTts!.speak(word);
  }

  // بدء الاستماع لتحليل نطق الطفل
  void _startListening() async {
    bool available = await speechToText!.initialize();
    if (available) {
      setState(() => isListening = true);
      speechToText!.listen(onResult: (result) {
        setState(() {
          feedback = _checkPronunciation(result.recognizedWords);
        });
      });
    } else {
      setState(() => isListening = false);
    }
  }

  // إيقاف الاستماع
  void _stopListening() {
    setState(() => isListening = false);
    speechToText!.stop();
  }

  // مقارنة النطق بالنطق الصحيح
  String _checkPronunciation(String spokenWord) {
    String correctWord = words[currentIndex]['word']!;
    if (spokenWord.toLowerCase() == correctWord.toLowerCase()) {
      _stopListening();
      return "أحسنت! نطقك صحيح.";
    } else {
      _stopListening();
      return "حاول مرة أخرى، نطقك كان: $spokenWord";
    }
  }

  // الانتقال إلى الكلمة التالية
  void _nextWord() {
    setState(() {
      _stopListening();
      currentIndex = (currentIndex + 1) % words.length; // الانتقال بين الكلمات
      feedback = ""; // إعادة ضبط الملاحظات
      _animationController.reset();
      _animationController.forward(); // إعادة تشغيل الرسوم المتحركة
    });
  }

  @override
  Widget build(BuildContext context) {
    String word = words[currentIndex]['word']!;
    String image = words[currentIndex]['image']!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('تعلم الكلمات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Progress bar to show current progress
              LinearProgressIndicator(
                value: (currentIndex + 1) / words.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              // عرض الصورة
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Image.asset(
                  image,
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              // عرض الكلمة
              Text(
                word,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // زر لنطق الكلمة
              ElevatedButton(
                onPressed: () => _speak(word),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'نطق الكلمة',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              // زر للبدء في تصحيح النطق
              ElevatedButton(
                onPressed: isListening ? _stopListening : _startListening,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  isListening ? 'إيقاف الاستماع' : 'ابدأ التحدث',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              // عرض ملاحظات تصحيح النطق
              Text(
                feedback,
                style: TextStyle(
                  fontSize: 24,
                  color: feedback.contains("أحسنت") ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // زر للانتقال إلى الكلمة التالية
              ElevatedButton(
                onPressed: _nextWord,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'التالي',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
