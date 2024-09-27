import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SentencesLearningScreen extends StatefulWidget {
  const SentencesLearningScreen({super.key});

  @override
  _SentencesLearningScreenState createState() =>
      _SentencesLearningScreenState();
}

class _SentencesLearningScreenState extends State<SentencesLearningScreen>
    with SingleTickerProviderStateMixin {
  FlutterTts? flutterTts;
  stt.SpeechToText? speechToText;
  bool isListening = false;
  String feedback = "";
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  List<Map<String, String>> sentences = [
    {"sentence": "I have a cat", "translation": "لدي قطة"},
    {"sentence": "The sun is bright", "translation": "الشمس مشرقة"},
    {
      "sentence": "She likes to read books",
      "translation": "هي تحب قراءة الكتب"
    },
    {"sentence": "He is playing with a ball", "translation": "هو يلعب بالكرة"},
    {
      "sentence": "We are going to the park",
      "translation": "نحن ذاهبون إلى الحديقة"
    },
    {"sentence": "The sky is blue", "translation": "السماء زرقاء"},
    {"sentence": "They are eating lunch", "translation": "هم يتناولون الغداء"},
    {"sentence": "The dog is barking", "translation": "الكلب ينبح"},
    {"sentence": "I can jump high", "translation": "أستطيع القفز عالياً"},
    {"sentence": "It is raining outside", "translation": "إنها تمطر في الخارج"},
    {"sentence": "She has a red hat", "translation": "لديها قبعة حمراء"},
    {"sentence": "The bird is singing", "translation": "العصفور يغني"},
    {"sentence": "He is riding a bike", "translation": "هو يركب الدراجة"},
    {"sentence": "We are happy today", "translation": "نحن سعداء اليوم"},
    {"sentence": "The tree is tall", "translation": "الشجرة طويلة"},
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    speechToText = stt.SpeechToText();

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

  Future<void> _speak(String sentence) async {
    await flutterTts!.setLanguage("en-US");
    await flutterTts!.setSpeechRate(0.5);
    await flutterTts!.speak(sentence);
  }

  void _startListening() async {
    bool available = await speechToText!.initialize();
    if (available) {
      setState(() => isListening = true);
      speechToText!.listen(onResult: (result) {
        if (result.finalResult) {
          // Check if the user has finished speaking
          setState(() {
            feedback = _checkPronunciation(result.recognizedWords);
            _stopListening(); // Stop listening after the final result
          });
        }
      });
    } else {
      setState(() => isListening = false);
    }
  }

  void _stopListening() {
    setState(() => isListening = false);
    speechToText!.stop();
  }

  String _checkPronunciation(String spokenSentence) {
    String correctSentence = sentences[currentIndex]['sentence']!;
    if (spokenSentence.toLowerCase() == correctSentence.toLowerCase()) {
      _stopListening();
      return "أحسنت! نطقك صحيح.";
    } else {
      _stopListening();
      return "حاول مرة أخرى، نطقك كان: $spokenSentence";
    }
  }

  void _nextSentence() {
    setState(() {
      _stopListening();
      currentIndex = (currentIndex + 1) % sentences.length;
      feedback = "";
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    String sentence = sentences[currentIndex]['sentence']!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('تعلم الجمل البسيطة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                value: (currentIndex + 1) / sentences.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    sentence,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _speak(sentence),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'نطق الجملة',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: _nextSentence,
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
