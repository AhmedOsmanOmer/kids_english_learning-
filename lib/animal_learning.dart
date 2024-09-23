import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // مكتبة لتحويل النص إلى كلام
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // مكتبة لتحويل الكلام إلى نص

class AnimalsLearningScreen extends StatefulWidget {
  const AnimalsLearningScreen({super.key});

  @override
  _AnimalsLearningScreenState createState() => _AnimalsLearningScreenState();
}

class _AnimalsLearningScreenState extends State<AnimalsLearningScreen>
    with SingleTickerProviderStateMixin {
  FlutterTts? flutterTts; // لتحويل النص إلى كلام
  stt.SpeechToText? speechToText; // لتحويل الكلام إلى نص
  bool isListening = false;
  String feedback = ""; // ملاحظات تصحيح النطق
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  List<Map<String, String>> animals = [
    {"name": "Lion", "image": "assets/lion.png"},
    {"name": "Elephant", "image": "assets/elephant.png"},
    {"name": "Dog", "image": "assets/dog.png"},
    {"name": "Cat", "image": "assets/cat.png"},
  ];

  int currentIndex = 0; // الفهرس الحالي للحيوان

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts(); // تهيئة TTS
    speechToText = stt.SpeechToText(); // تهيئة Speech-to-Text

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
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

  // نطق اسم الحيوان باستخدام TTS
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
    String correctWord = animals[currentIndex]['name']!;
    if (spokenWord.toLowerCase() == correctWord.toLowerCase()) {
      _stopListening();
      return "أحسنت! نطقك صحيح.";
    } else {
      _stopListening();
      return "حاول مرة أخرى، نطقك كان: $spokenWord";
    }
  }

  // الانتقال إلى الحيوان التالي
  void _nextAnimal() {
    setState(() {
      _stopListening();
      currentIndex =
          (currentIndex + 1) % animals.length; // الانتقال بين الحيوانات
      feedback = ""; // إعادة ضبط الملاحظات
      _animationController.reset(); // إعادة تعيين الرسوم المتحركة
      _animationController.forward(); // تشغيل الرسوم المتحركة مرة أخرى
    });
  }

  @override
  Widget build(BuildContext context) {
    String animalName = animals[currentIndex]['name']!;
    String animalImage = animals[currentIndex]['image']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعلم أسماء الحيوانات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Progress bar to show current progress
              LinearProgressIndicator(
                value: (currentIndex + 1) / animals.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              // عرض صورة الحيوان مع الرسوم المتحركة
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Image.asset(
                  animalImage,
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 150,
                      color: Colors.red,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // عرض اسم الحيوان
              Text(
                animalName,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // زر لنطق اسم الحيوان
              ElevatedButton(
                onPressed: () => _speak(animalName),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'نطق اسم الحيوان',
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
              // زر للانتقال إلى الحيوان التالي
              ElevatedButton(
                onPressed: _nextAnimal,
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
