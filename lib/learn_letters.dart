import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // مكتبة لتحويل النص إلى كلام
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // مكتبة لتحويل الكلام إلى نص

class LettersLearningScreen extends StatefulWidget {
  const LettersLearningScreen({super.key});

  @override
  _LettersLearningScreenState createState() => _LettersLearningScreenState();
}

class _LettersLearningScreenState extends State<LettersLearningScreen>
    with SingleTickerProviderStateMixin {
  FlutterTts? flutterTts; // لتحويل النص إلى كلام
  stt.SpeechToText? speechToText; // لتحويل الكلام إلى نص
  bool isListening = false;
  String feedback = ""; // ملاحظات تصحيح النطق
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  // قائمة الأحرف مع الكلمات المرتبطة وصورها
  List<Map<String, String>> letters = [
    {"letter": "A", "word": "  Apple", "image": "assets/apple.png"},
    {"letter": "B", "word": "  Ball", "image": "assets/ball.png"},
    {"letter": "C", "word": "  Cat", "image": "assets/cat.png"},
    {"letter": "D", "word": "  Dog", "image": "assets/dog.png"},
    {"letter": "E", "word": "  Elephant", "image": "assets/elephant.png"},
  ];

  int currentIndex = 0; // الفهرس الحالي للحرف

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

  // نطق الحرف والكلمة المرتبطة به باستخدام TTS
  Future<void> _speak(String letter, String word) async {
    await flutterTts!.setLanguage("en-US");
    await flutterTts!.setSpeechRate(0.5); // ضبط سرعة النطق
    await flutterTts!.speak("$letter for $word"); // نطق الحرف والكلمة
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
    String correctWord = letters[currentIndex]['word']!;
    if (spokenWord.toLowerCase() == correctWord.toLowerCase()) {
      _stopListening();
      return "أحسنت! نطقك صحيح.";
    } else {
      _stopListening();
      return "حاول مرة أخرى، نطقك كان: $spokenWord";
    }
  }

  // الانتقال إلى الحرف التالي
  void _nextLetter() {
    setState(() {
      _stopListening();
      currentIndex = (currentIndex + 1) % letters.length; // الانتقال بين الأحرف
      feedback = ""; // إعادة ضبط الملاحظات
      _animationController.reset(); // إعادة تعيين الرسوم المتحركة
      _animationController.forward(); // تشغيل الرسوم المتحركة مرة أخرى
    });
  }

  @override
  Widget build(BuildContext context) {
    String letter = letters[currentIndex]['letter']!;
    String word = letters[currentIndex]['word']!;
    String image = letters[currentIndex]['image']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعلم الأحرف'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Progress bar to show the current progress
              LinearProgressIndicator(
                value: (currentIndex + 1) / letters.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              // عرض صورة الكلمة مع الرسوم المتحركة
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Image.asset(
                  image,
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              // عرض الحرف
              Text(
                letter,
                style:
                    const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // عرض الكلمة المرتبطة بالحرف
              Text(
                word,
                style: TextStyle(fontSize: 40, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              // زر لنطق الحرف والكلمة
              ElevatedButton(
                onPressed: () => _speak(letter, word),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'نطق الحرف والكلمة',
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
              // عرض ملاحظات تصحيح النطق مع التفاعل
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  feedback,
                  style: TextStyle(
                    fontSize: 24,
                    color:
                        feedback.contains("أحسنت") ? Colors.green : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // زر للانتقال إلى الحرف التالي
              ElevatedButton(
                onPressed: _nextLetter,
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
