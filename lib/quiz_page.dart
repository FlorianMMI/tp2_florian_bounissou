import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'models.dart';
import 'question_text.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}


final List<Question> questions = [
    Question(
      question: 'Quelle entreprise développe Flutter ?',
      answers: [
        Answer(text: 'Google', isCorrect: true),
        Answer(text: 'Apple', isCorrect: false),
        Answer(text: 'Microsoft', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel langage est utilisé avec Flutter ?',
      answers: [
        Answer(text: 'Kotlin', isCorrect: false),
        Answer(text: 'Dart', isCorrect: true),
        Answer(text: 'Swift', isCorrect: false),
      ],
    ),
  Question(
    question: 'Quel widget permet d\'afficher une liste défilante ?',
    answers: [
      Answer(text: 'ListView', isCorrect: true),
      Answer(text: 'Column', isCorrect: false),
      Answer(text: 'Row', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quelle méthode appelle-t-on pour mettre à jour l\'interface dans un StatefulWidget ?',
    answers: [
      Answer(text: 'initState', isCorrect: false),
      Answer(text: 'setState', isCorrect: true),
      Answer(text: 'dispose', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quel est le nom du fichier principal d\'une application Flutter ?',
    answers: [
      Answer(text: 'main.dart', isCorrect: true),
      Answer(text: 'app.dart', isCorrect: false),
      Answer(text: 'flutter.dart', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quel type représente une chaîne de caractères en Dart ?',
    answers: [
      Answer(text: 'String', isCorrect: true),
      Answer(text: 'int', isCorrect: false),
      Answer(text: 'bool', isCorrect: false),
    ],
  ),
  Question(
    question: 'Quel outil gère les dépendances dans Flutter ?',
    answers: [
      Answer(text: 'pub', isCorrect: true),
      Answer(text: 'npm', isCorrect: false),
      Answer(text: 'pip', isCorrect: false),
    ],
  ),
  ];



class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  int totalQuestions = questions.length;
  int? selectedAnswerIndex;
  bool animation = false;
  bool showCountdown = false;
  int countdown = 3;
  List color = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
  ]; // Liste de couleur qui servira pour le background de chaque question
  

  // Fonction appelée lorsqu'une réponse est sélectionnée

  void answerQuestion (bool isCorrect) async {

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse.'),
          duration: const Duration(seconds: 1),
        ),
    ); // Afficher le SnackBar (Message temporaire en bas de l'écran)
    setState(() {
      animation = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      animation = false;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (isCorrect) score++;
    
    // Afficher le compteur
    setState(() {
      if( currentQuestion >= questions.length -1){
        showCountdown = false; 
        return;
      }
      showCountdown = true;
      countdown = 3;
    });
    
    // Compte à rebours
    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        countdown = i - 1;
      });
    }
    
    // Passer à la question suivante
    setState(() {
      showCountdown = false;
      currentQuestion++;
      selectedAnswerIndex = null;
      countdown = 3;
    });
  }

  void selectAnswer(int index){
    setState(() {
      selectedAnswerIndex = index;
    });
  }

  void shareScore() {
  
  print('Coucou');
  SharePlus.instance.share(
    ShareParams(text: 'J\'ai obtenu un score de $score sur $totalQuestions au quiz Flutter ! Essayez-le vous aussi !'),
  );

  }

  // On passe  sur un QCM à choix multiple (On peut valider plusieur réponse)

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Résultat du score')),
        backgroundColor: const Color.fromARGB(255, 230, 218, 248),
        body: Center(
         
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (score >= questions.length / 2)
                Icon(Icons.thumb_up,
                  size: 100,
                  color: Colors.deepPurple.shade300)
              else (Icon(Icons.thumb_down,
                  size: 100,
                  color: Colors.deepPurple.shade300)),
              const SizedBox(height: 20),
              Text('Score final : $score / ${questions.length}',
                  style: const TextStyle(fontSize: 24)),
              Text('${((score / questions.length) * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(fontSize: 20, color: Colors.lightGreen)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentQuestion = 0;
                    score = 0;
                  });
                },
                child: const Text('Rejouer'),
              ),
              ElevatedButton(onPressed: shareScore, child: const Text('Partager le score')),
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Flutter - Question ${currentQuestion + 1} / $totalQuestions')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color[currentQuestion % color.length].withOpacity(0.3), // On pioche une couleur en rapport de la liste de couleurs set plus tôt
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: showCountdown
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Question suivante dans...',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      countdown > 0 ? '$countdown' : 'Go !',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Question ${currentQuestion + 1} / $totalQuestions',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            QuestionText(questionText: question.question),
            const SizedBox(height: 20),
            // On génère les boutons de réponse directement ici
            
            ...question.answers.asMap().entries.map((entry) {
              int index = entry.key;
              Answer answer = entry.value;
              return AnimatedScale(
                duration: Duration(milliseconds: 300),
                scale: selectedAnswerIndex == index ? 0.98 : 1.0,
                child: Container(
                  
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedAnswerIndex == index
                          ? const Color.fromARGB(255, 199, 217, 231)
                          : null,
                      
                    ),
                    onPressed: () => selectAnswer(index),
                    child: Text(answer.text),
                  ),
                ),
              );

            
            }),
            const SizedBox(height: 20),
            
           
                AnimatedScale(
                  duration: Duration(milliseconds: 300),
                  scale: animation ? 0.9 : 1.0,
                  child: AnimatedContainer(
                    
                    duration: const Duration(milliseconds: 300),
                    
                      width: 250,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 121, 219, 124),
                        ),
                        onPressed: selectedAnswerIndex != null 
                          ? () => answerQuestion(question.answers[selectedAnswerIndex!].isCorrect)
                          : null, // si null il se grise automatiquement 
                        child: const Text('Valider'),
                      ),
                            ),
                ),
              
            
          ],
          ),
        ),
      ),
    );
  }
}