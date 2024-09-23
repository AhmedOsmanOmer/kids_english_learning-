import 'package:learn_english_app/animal_learning.dart';
import 'package:learn_english_app/colors_learning.dart';
import 'package:learn_english_app/learn_letters.dart';
import 'package:learn_english_app/learn_numbers.dart';
import 'package:learn_english_app/learn_sentance.dart';
import 'package:learn_english_app/learn_verbs.dart';
import 'package:learn_english_app/learn_word.dart';
import 'package:flutter/material.dart';
import 'package:learn_english_app/quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تعلم اللغة الانجليزية',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4.0, // Adds a subtle shadow effect
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 20.0, // Horizontal spacing between icons
          mainAxisSpacing: 20.0, // Vertical spacing between icons
          children: <Widget>[
            _buildGridItem(
              context: context,
              icon: Icons.language,
              color: Colors.blue,
              label: 'تعلم الكلمات',
              screen: const WordLearningScreen(),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.palette,
              color: Colors.red,
              label: 'تعلم الألوان',
              screen: const ColorsLearningScreen(),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.pets,
              color: Colors.green,
              label: 'تعلم أسماء الحيوانات',
              screen: const AnimalsLearningScreen(),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.looks_one,
              color: Colors.orange,
              label: 'تعلم الأرقام',
              screen: const NumbersLearningScreen(),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.menu_book,
              color: Colors.purple,
              label: 'تعلم الجمل',
              screen: const SentencesLearningScreen(),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.translate,
              color: Colors.indigo,
              label: 'تعلم الأفعال والضمائر',
              screen: VerbsAndPronounsLearningScreen(),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.abc, // Changed to better reflect letters
              color: Colors.teal,
              label: 'تعلم الأحرف',
              screen: const LettersLearningScreen(),
            ),
            _buildGridItem(
              context: context,
              icon: Icons.quiz, // Changed to better reflect letters
              color: Colors.teal,
              label: 'االتمارين',
              screen: QuizScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each grid item with a hover effect and tap interaction
  Widget _buildGridItem({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Animated icon with hover effect
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 80,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            // Text label for the grid item
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
