import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // مكتبة لتحويل النص إلى كلام
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // مكتبة لتحويل الكلام إلى نص

class VerbsAndPronounsLearningScreen extends StatefulWidget {
  const VerbsAndPronounsLearningScreen({super.key});

  @override
  _VerbsAndPronounsLearningScreenState createState() =>
      _VerbsAndPronounsLearningScreenState();
}

class _VerbsAndPronounsLearningScreenState
    extends State<VerbsAndPronounsLearningScreen>
    with SingleTickerProviderStateMixin {
  FlutterTts? flutterTts; // تحويل النص إلى كلام
  stt.SpeechToText? speechToText; // تحويل الكلام إلى نص
  bool isListening = false;
  String feedback = ""; // ملاحظات تصحيح النطق
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  List<Map<String, String>> items = [
    {"type": "verb", "word": "Run", "translation": "يجري"},
    {"type": "verb", "word": "Eat", "translation": "يأكل"},
    {"type": "verb", "word": "Sleep", "translation": "ينام"},
    {"type": "pronoun", "word": "I", "translation": "أنا"},
    {"type": "pronoun", "word": "You", "translation": "أنت"},
    {"type": "pronoun", "word": "We", "translation": "نحن"},
  ];

  int currentIndex = 0; // الفهرس الحالي

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
    _animationController.forward();
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

  // بدء الاستماع لتحليل النطق
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
    String correctWord = items[currentIndex]['word']!;
    if (spokenWord.toLowerCase() == correctWord.toLowerCase()) {
      _stopListening();
      return "أحسنت! نطقك صحيح.";
    } else {
      _stopListening();
      return "حاول مرة أخرى، نطقك كان: $spokenWord";
    }
  }

  // الانتقال إلى العنصر التالي
  void _nextItem() {
    setState(() {
      _stopListening();
      currentIndex = (currentIndex + 1) % items.length;
      feedback = ""; // إعادة ضبط الملاحظات
      _animationController.reset();
      _animationController.forward(); // إعادة الرسوم المتحركة
    });
  }

  @override
  Widget build(BuildContext context) {
    String type = items[currentIndex]['type']!;
    String word = items[currentIndex]['word']!;
    String translation = items[currentIndex]['translation']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعلم الأفعال والضمائر'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Progress bar to show current progress
              LinearProgressIndicator(
                value: (currentIndex + 1) / items.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              // عرض نوع الكلمة (فعل أو ضمير)
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Text(
                  type == "verb" ? "فعل" : "ضمير",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // عرض الكلمة
              Text(
                word,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // عرض الترجمة
              Text(
                translation,
                style: TextStyle(fontSize: 30, color: Colors.grey[700]),
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
              // زر للانتقال إلى العنصر التالي
              ElevatedButton(
                onPressed: _nextItem,
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
