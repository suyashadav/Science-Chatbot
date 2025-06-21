import 'package:flutter/material.dart';
import 'home.dart';
import 'resources_page.dart';
import 'chatbot_page.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzes App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const QuizzesPage(),
    );
  }
}

class QuizzesPage extends StatelessWidget {
  const QuizzesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
        backgroundColor: const Color(0xFFFBE4A7),
      ),
      backgroundColor: const Color(0xFFFBE4A7),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ChapterCard(
            chapterName: "Living World and Classification of Microbes",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterQuizScreen(
                    chapterTitle: "Living World and Classification of Microbes",
                    questions: classificationQuestions,
                  ),
                ),
              );
            },
          ),
          ChapterCard(
            chapterName: "Health and Diseases",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterQuizScreen(
                    chapterTitle: "Health and Diseases",
                    questions: healthQuestions,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black54,
            currentIndex: 3,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/home1.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/home1.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/resource.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/resource.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Resource',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/bubble-chat.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/bubble-chat.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Chat-Bot',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/ideas.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/ideas.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Quiz',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/user.png",
                  width: 24,
                  color: Colors.black54,
                ),
                activeIcon: Image.asset(
                  "assets/images/user.png",
                  width: 24,
                  color: Colors.green,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                // break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResourcesPage()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatbotPage()),
                  );
                  break;
                case 3:
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const QuizzesPage()),
                  // );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}

// Chapter 1 Questions
final List<Map<String, dynamic>> classificationQuestions = [
  {
    'question': 'Who proposed the 5-kingdom classification system?',
    'options': [
      'Carl Linnaeus',
      'Robert Whittaker (1969)',
      'Ernst Haeckel',
      'Charles Darwin'
    ],
    'correctAnswer': 'Robert Whittaker (1969)',
  },
  {
    'question': 'What are the five kingdoms in Whittaker\'s system?',
    'options': [
      'Animals, Plants, Fungi, Protists, Bacteria',
      'Monera, Protista, Fungi, Plantae, Animalia',
      'Prokaryotes, Eukaryotes, Plants, Animals, Fungi',
      'Viruses, Bacteria, Fungi, Plants, Animals'
    ],
    'correctAnswer': 'Monera, Protista, Fungi, Plantae, Animalia',
  },
  {
    'question': 'Which kingdom includes prokaryotic organisms?',
    'options': ['Protista', 'Fungi', 'Monera', 'Plantae'],
    'correctAnswer': 'Monera',
  },
  {
    'question': 'Name a bacteria found in curd.',
    'options': ['E. coli', 'Lactobacilli', 'Salmonella', 'Streptococcus'],
    'correctAnswer': 'Lactobacilli',
  },
  {
    'question': 'How do bacteria reproduce?',
    'options': [
      'Budding',
      'Binary fission',
      'Spore formation',
      'Sexual reproduction'
    ],
    'correctAnswer': 'Binary fission',
  },
  {
    'question': 'True or False: Bacteria have a well-defined nucleus.',
    'options': ['True', 'False'],
    'correctAnswer': 'False',
  },
  {
    'question': 'Which protozoan causes malaria?',
    'options': ['Amoeba proteus', 'Plasmodium vivax', 'Paramecium', 'Euglena'],
    'correctAnswer': 'Plasmodium vivax',
  },
  {
    'question': 'What structure does Amoeba use for movement?',
    'options': ['Cilia', 'Flagella', 'Pseudopodia', 'Tentacles'],
    'correctAnswer': 'Pseudopodia',
  },
  {
    'question': 'Give an example of an autotrophic protist.',
    'options': ['Amoeba', 'Paramecium', 'Euglena', 'Plasmodium'],
    'correctAnswer': 'Euglena',
  },
  {
    'question': 'What is the fungal cell wall made of?',
    'options': ['Cellulose', 'Chitin', 'Peptidoglycan', 'Silica'],
    'correctAnswer': 'Chitin',
  },
  {
    'question': 'How do fungi obtain nutrients?',
    'options': [
      'Photosynthesis',
      'Saprotrophism (from decaying matter)',
      'Hunting other organisms',
      'Absorbing minerals from soil'
    ],
    'correctAnswer': 'Saprotrophism (from decaying matter)',
  },
  {
    'question': 'Name a unicellular fungus.',
    'options': [
      'Mushroom',
      'Baker\'s yeast (Saccharomyces)',
      'Penicillium',
      'Aspergillus'
    ],
    'correctAnswer': 'Baker\'s yeast (Saccharomyces)',
  },
  {
    'question': 'Why are viruses considered non-living?',
    'options': [
      'They are too small',
      'They lack cellular structure and need a host to replicate',
      'They don\'t move',
      'They don\'t contain DNA'
    ],
    'correctAnswer':
        'They lack cellular structure and need a host to replicate',
  },
  {
    'question': 'Name a plant disease caused by a virus.',
    'options': [
      'Tomato wilt virus',
      'Bacterial leaf spot',
      'Powdery mildew',
      'Root rot'
    ],
    'correctAnswer': 'Tomato wilt virus',
  },
  {
    'question': 'What microscope is needed to observe viruses?',
    'options': [
      'Light microscope',
      'Electron microscope',
      'Compound microscope',
      'Stereo microscope'
    ],
    'correctAnswer': 'Electron microscope',
  },
];

// Chapter 2 Questions
final List<Map<String, dynamic>> healthQuestions = [
  {
    'question': 'What distinguishes infectious from non-infectious diseases?',
    'options': [
      'Infectious diseases are more severe',
      'Infectious diseases spread via pathogens, non-infectious arise from internal factors',
      'Non-infectious diseases are always genetic',
      'There is no difference'
    ],
    'correctAnswer':
        'Infectious diseases spread via pathogens, non-infectious arise from internal factors',
  },
  {
    'question': 'Which disease is NOT infectious?',
    'options': ['Tuberculosis', 'Diabetes', 'Dengue', 'Cholera'],
    'correctAnswer': 'Diabetes',
  },
  {
    'question': 'How is tuberculosis primarily transmitted?',
    'options': [
      'Through contaminated water',
      'Through air (sputum droplets)',
      'Through mosquito bites',
      'Through physical touch'
    ],
    'correctAnswer': 'Through air (sputum droplets)',
  },
  {
    'question': 'Which mosquito spreads dengue?',
    'options': ['Anopheles', 'Aedes aegypti', 'Culex', 'Tsetse fly'],
    'correctAnswer': 'Aedes aegypti',
  },
  {
    'question': 'What is the main symptom of rabies?',
    'options': [
      'High fever',
      'Hydrophobia (fear of water)',
      'Skin rash',
      'Joint pain'
    ],
    'correctAnswer': 'Hydrophobia (fear of water)',
  },
  {
    'question': 'Which pathogen causes cholera?',
    'options': [
      'Vibrio cholerae',
      'Plasmodium vivax',
      'Mycobacterium tuberculae',
      'HIV'
    ],
    'correctAnswer': 'Vibrio cholerae',
  },
  {
    'question': 'HIV/AIDS is transmitted through:',
    'options': [
      'Hugging',
      'Blood transfusion',
      'Sharing food',
      'Mosquito bites'
    ],
    'correctAnswer': 'Blood transfusion',
  },
  {
    'question': 'What is a primary cause of lung cancer?',
    'options': [
      'Eating junk food',
      'Smoking/tobacco use',
      'Lack of exercise',
      'Drinking coffee'
    ],
    'correctAnswer': 'Smoking/tobacco use',
  },
  {
    'question': 'Which hormone deficiency leads to diabetes?',
    'options': ['Adrenaline', 'Insulin', 'Thyroxine', 'Estrogen'],
    'correctAnswer': 'Insulin',
  },
  {
    'question': 'Name two symptoms of a heart attack.',
    'options': [
      'Headache and dizziness',
      'Severe chest pain and shortness of breath',
      'Stomach ache and nausea',
      'Joint pain and fever'
    ],
    'correctAnswer': 'Severe chest pain and shortness of breath',
  },
  {
    'question': 'How can dengue be prevented?',
    'options': [
      'Taking antibiotics',
      'Eliminating stagnant water',
      'Wearing warm clothes',
      'Avoiding dairy products'
    ],
    'correctAnswer': 'Eliminating stagnant water',
  },
  {
    'question': 'What is the purpose of the BCG vaccine?',
    'options': [
      'To prevent malaria',
      'To prevent tuberculosis',
      'To prevent cholera',
      'To prevent AIDS'
    ],
    'correctAnswer': 'To prevent tuberculosis',
  },
  {
    'question': 'Why are generic medicines significant?',
    'options': [
      'They taste better',
      'They are more expensive',
      'They are affordable and equally effective',
      'They work faster'
    ],
    'correctAnswer': 'They are affordable and equally effective',
  },
  {
    'question': 'Which day is observed as World Health Day?',
    'options': ['April 7th', 'June 5th', 'October 10th', 'December 1st'],
    'correctAnswer': 'April 7th',
  },
  {
    'question':
        'True or False: AIDS can spread by touching an infected person.',
    'options': ['True', 'False'],
    'correctAnswer': 'False',
  },
];

class ChapterCard extends StatelessWidget {
  final String chapterName;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.chapterName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          chapterName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class ChapterQuizScreen extends StatefulWidget {
  final String chapterTitle;
  final List<Map<String, dynamic>> questions;

  const ChapterQuizScreen({
    super.key,
    required this.chapterTitle,
    required this.questions,
  });

  @override
  State<ChapterQuizScreen> createState() => _ChapterQuizScreenState();
}

class _ChapterQuizScreenState extends State<ChapterQuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool quizCompleted = false;
  Map<int, String?> selectedAnswers = {};

  void _answerQuestion(String selectedAnswer) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = selectedAnswer;
      if (selectedAnswer ==
          widget.questions[currentQuestionIndex]['correctAnswer']) {
        score++;
      }

      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        quizCompleted = true;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      quizCompleted = false;
      selectedAnswers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterTitle),
        backgroundColor: const Color(0xFFFBE4A7),
      ),
      backgroundColor: const Color(0xFFFBE4A7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: quizCompleted
            ? QuizResult(
                score: score,
                totalQuestions: widget.questions.length,
                onRetry: _resetQuiz,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / widget.questions.length,
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal[800],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.questions[currentQuestionIndex]['question']
                            as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (widget.questions[currentQuestionIndex]
                              ['options'] as List)
                          .length,
                      itemBuilder: (context, index) {
                        final option = (widget.questions[currentQuestionIndex]
                                ['options'] as List)[index]
                            .toString();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswers[
                                          currentQuestionIndex] ==
                                      option
                                  ? (option ==
                                          widget.questions[currentQuestionIndex]
                                              ['correctAnswer']
                                      ? Colors.green
                                      : Colors.red)
                                  : Colors.white,
                              foregroundColor:
                                  selectedAnswers[currentQuestionIndex] ==
                                          option
                                      ? Colors.white
                                      : Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (selectedAnswers[currentQuestionIndex] ==
                                  null) {
                                _answerQuestion(option);
                              }
                            },
                            child: Text(option),
                          ),
                        );
                      },
                    ),
                  ),
                  if (selectedAnswers[currentQuestionIndex] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentQuestionIndex <
                              widget.questions.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                            });
                          } else {
                            setState(() {
                              quizCompleted = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          currentQuestionIndex == widget.questions.length - 1
                              ? 'Submit Quiz'
                              : 'Next Question',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class QuizResult extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRetry;

  const QuizResult({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Quiz Completed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          const SizedBox(height: 20),
          CircularProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.teal[800],
            strokeWidth: 10,
          ),
          const SizedBox(height: 20),
          Text(
            'Your Score: $score/$totalQuestions ($percentage%)',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            percentage >= 70
                ? 'Excellent! 🎉'
                : percentage >= 40
                    ? 'Good job! 👍'
                    : 'Keep practicing! 📚',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[800],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
