import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // مكتبة لتحويل النص إلى كلام
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // مكتبة لتحويل الكلام إلى نص

class NumbersLearningScreen extends StatefulWidget {
  const NumbersLearningScreen({super.key});

  @override
  _NumbersLearningScreenState createState() => _NumbersLearningScreenState();
}

class _NumbersLearningScreenState extends State<NumbersLearningScreen>
    with SingleTickerProviderStateMixin {
  FlutterTts? flutterTts; // تحويل النص إلى كلام
  stt.SpeechToText? speechToText; // تحويل الكلام إلى نص
  bool isListening = false;
  String feedback = ""; // ملاحظات تصحيح النطق
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  List numbers = [
    {"number": "1", "image": "assets/1.png"},
    {"number": "2", "image": "assets/2.png"},
    {"number": "3", "image": "assets/3.png"},
    {"number": "4", "image": "assets/4.png"},
    {"number": "5", "image": "assets/5.png"},
    {"number": "6", "image": "assets/6.png"},
    {"number": "7", "image": "assets/7.png"},
    {"number": "8", "image": "assets/8.png"},
    {"number": "9", "image": "assets/9.png"},
    {"number": "10", "image": "assets/10.png"},
    {"number": "11", "image": "assets/11.png"},
    {"number": "12", "image": "assets/12.png"},
    {"number": "13", "image": "assets/13.png"},
    {"number": "14", "image": "assets/14.png"},
    {"number": "15", "image": "assets/15.png"},
    {"number": "16", "image": "assets/16.png"},
    {"number": "17", "image": "assets/17.png"},
    {"number": "18", "image": "assets/18.png"},
    {"number": "19", "image": "assets/19.png"},
    {"number": "20", "image": "assets/20.png"},
  ];

  int currentIndex = 0; // الفهرس الحالي للرقم

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

  // نطق الرقم باستخدام TTS
  Future<void> _speak(String number) async {
    await flutterTts!.setLanguage("en-US");
    await flutterTts!.setSpeechRate(0.5);
    await flutterTts!.speak(number);
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
    String correctWord = numbers[currentIndex]['number']!;
    if (spokenWord.toLowerCase() == correctWord.toLowerCase()) {
      _stopListening();
      return "أحسنت! نطقك صحيح.";
    } else {
      _stopListening();
      return "حاول مرة أخرى، نطقك كان: $spokenWord";
    }
  }

  // الانتقال إلى الرقم التالي
  void _nextNumber() {
    setState(() {
      _stopListening();
      currentIndex =
          (currentIndex + 1) % numbers.length; // الانتقال بين الأرقام
      feedback = ""; // إعادة ضبط الملاحظات
      _animationController.reset(); // إعادة تشغيل الرسوم المتحركة
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    String number = numbers[currentIndex]['number']!;
    String image = numbers[currentIndex]['image']!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('تعلم الأرقام'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Progress bar to show current progress
              LinearProgressIndicator(
                value: (currentIndex + 1) / numbers.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
              ),
              /*  const SizedBox(height: 20),
              // عرض صورة الرقم مع الرسوم المتحركة
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Text(
                  'assets/$image.png',
                ),
              ), */
              const SizedBox(height: 20),
              // عرض الرقم
              Text(
                number,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // زر لنطق الرقم
              ElevatedButton(
                onPressed: () => _speak(number),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'نطق الرقم',
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
              // زر للانتقال إلى الرقم التالي
              ElevatedButton(
                onPressed: _nextNumber,
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
