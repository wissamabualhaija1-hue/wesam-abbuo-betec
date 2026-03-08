import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  bool _showCorrectEffect = false;
  bool _showWrongEffect = false;

  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedLevel;
  bool quizFinished = false;
  int? lastSelectedAnswer;

  final Map<String, List<Map<String, dynamic>>> levelsQuestions = {
    'مبتدئ': [
      {
        'q': 'ما هي عاصمة الأردن؟',
        'a': ['عمان', 'إربد', 'العقبة'],
        'i': 0,
      },
      {
        'q': 'أين تقع الخزنة؟',
        'a': ['جرش', 'البتراء', 'مادبا'],
        'i': 1,
      },
      {
        'q': 'ما هو لون علم الثورة العربية؟',
        'a': ['أحمر/أسود/أخضر/أبيض', 'أزرق/أصفر', 'أبيض/فضي'],
        'i': 0,
      },
      {
        'q': 'أين يقع البحر الميت؟',
        'a': ['إربد', 'الأغوار', 'العقبة'],
        'i': 1,
      },
      {
        'q': 'ما هو الحيوان الوطني للأردن؟',
        'a': ['المها العربي', 'الجمل', 'الصقر'],
        'i': 0,
      },
      {
        'q': 'بماذا تشتهر مدينة مادبا؟',
        'a': ['بالخزنة', 'بالفسيفساء', 'بالقلاع'],
        'i': 1,
      },
      {
        'q': 'ما هي العملة الرسمية للأردن؟',
        'a': ['الدينار', 'الدرهم', 'الريال'],
        'i': 0,
      },
      {
        'q': 'أين تقع قلعة عجلون؟',
        'a': ['في الشمال', 'في الجنوب', 'في الشرق'],
        'i': 0,
      },
      {
        'q': 'ما هو المنفذ البحري الوحيد للأردن؟',
        'a': ['عمان', 'العقبة', 'الزرقاء'],
        'i': 1,
      },
      {
        'q': 'ما هو الرمز الهاتفي الدولي للأردن؟',
        'a': ['+962', '+966', '+971'],
        'i': 0,
      },
    ],
    'متوسط': [
      {
        'q': 'ما لقب مدينة جرش الأثرية؟',
        'a': ['الوردية', 'الألف عمود', 'وادي القمر'],
        'i': 1,
      },
      {
        'q': 'في أي محافظة تقع قلعة الكرك؟',
        'a': ['الكرك', 'الطفيلة', 'معان'],
        'i': 0,
      },
      {
        'q': 'من هو باني مدينة عمان الحديثة؟',
        'a': ['الأنباط', 'الرومان', 'الشركس والقبائل المحلية'],
        'i': 2,
      },
      {
        'q': 'ماذا يسمى وادي رم أيضاً؟',
        'a': ['وادي النجوم', 'وادي القمر', 'وادي الشمس'],
        'i': 1,
      },
      {
        'q': 'متى استقلت المملكة الأردنية الهاشمية؟',
        'a': ['1946م', '1952م', '1921م'],
        'i': 0,
      },
      {
        'q': 'ما هو أطول نهر في الأردن؟',
        'a': ['نهر اليرموك', 'نهر الأردن', 'نهر الزرقاء'],
        'i': 1,
      },
      {
        'q': 'أين تقع آثار "أم قيس"؟',
        'a': ['إربد', 'المفرق', 'جرش'],
        'i': 0,
      },
      {
        'q': 'ما هو أعلى جبل في الأردن؟',
        'a': ['جبل نيبو', 'جبل أم الدامي', 'جبل القلعة'],
        'i': 1,
      },
      {
        'q': 'من هو الملك الذي وضع الدستور الأردني الحالي؟',
        'a': ['الملك طلال', 'الملك حسين', 'الملك عبد الله الأول'],
        'i': 0,
      },
      {
        'q': 'ما هو اسم قلعة عمان القديمة؟',
        'a': ['الربض', 'جبل القلعة', 'الشوبك'],
        'i': 1,
      },
    ],
    'محترف': [
      {
        'q': 'في أي عام تم اكتشاف البتراء للعالم الحديث؟',
        'a': ['1812م', '1921م', '1750م'],
        'i': 0,
      },
      {
        'q': 'ما هو الاسم القديم لمدينة عمان؟',
        'a': ['جدارا', 'فيلادلفيا', 'أنتيوخ'],
        'i': 1,
      },
      {
        'q': 'من هو القائد الذي بنى قلعة الربض؟',
        'a': ['عز الدين أسامة', 'صلاح الدين', 'بيبرس'],
        'i': 0,
      },
      {
        'q': 'أي موقع مدرج على قائمة اليونسكو؟',
        'a': ['قصير عمرة', 'جبل القلعة', 'المدرج الروماني'],
        'i': 0,
      },
      {
        'q': 'ما هي المدينة التي كانت تسمى "أنتيوخيا بِيوس"؟',
        'a': ['جرش', 'مادبا', 'السلط'],
        'i': 0,
      },
      {
        'q': 'في أي عام استلم الملك عبدالله الثاني سلطاته الدستورية؟',
        'a': ['1999م', '2001م', '1998م'],
        'i': 0,
      },
      {
        'q': 'أين يقع قصر المشتى الأموي؟',
        'a': ['قرب مطار الملكة علياء', 'في معان', 'في عجلون'],
        'i': 0,
      },
      {
        'q': 'ما هي عاصمة الأنباط قبل البتراء؟',
        'a': ['السلع', 'بصيرا', 'مدين'],
        'i': 0,
      },
      {
        'q': 'ماذا تسمى لوحة الفسيفساء في مادبا؟',
        'a': ['خارطة الأراضي المقدسة', 'لوحة النصر', 'خارطة الملوك'],
        'i': 0,
      },
      {
        'q': 'كم تبلغ مساحة الأردن التقريبية؟',
        'a': ['89 ألف كم²', '120 ألف كم²', '75 ألف كم²'],
        'i': 0,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _playFeedbackSound(bool isCorrect) async {
    try {
      await _audioPlayer.stop();
      String fileName = isCorrect ? 'correct.mp3' : 'rong.mp3';
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint("خطأ في تشغيل الصوت: $e");
    }
  }

  void checkAnswer(int selectedIndex) {
    if (lastSelectedAnswer != null) return;
    setState(() => lastSelectedAnswer = selectedIndex);

    bool isCorrect =
        selectedIndex ==
        levelsQuestions[selectedLevel]![currentQuestionIndex]['i'];

    if (isCorrect) {
      score++;
      _playFeedbackSound(true);
      HapticFeedback.lightImpact();
      setState(() => _showCorrectEffect = true);
    } else {
      _playFeedbackSound(false);
      HapticFeedback.vibrate();
      setState(() => _showWrongEffect = true);
      _animationController.forward(from: 0.0);
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showCorrectEffect = false;
          _showWrongEffect = false;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          lastSelectedAnswer = null;
          if (currentQuestionIndex < 9) {
            currentQuestionIndex++;
          } else {
            quizFinished = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedLevel == null ? 'تحدي المعرفة' : 'مستوى $selectedLevel',
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.transparent : const Color(0xFF003366),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: selectedLevel == null
                  ? _buildLevelSelection(key: const ValueKey('selection'))
                  : (quizFinished
                        ? _buildResult(key: const ValueKey('result'))
                        : _buildQuizContent(key: const ValueKey('quiz'))),
            ),
          ),
          if (_showCorrectEffect)
            _buildFullScreenEffect(Colors.green, Icons.check_circle, "بطل!"),
          if (_showWrongEffect)
            _buildFullScreenEffect(Colors.red, Icons.cancel, "ركز يا نشمي!"),
        ],
      ),
    );
  }

  Widget _buildFullScreenEffect(Color color, IconData icon, String label) {
    return IgnorePointer(
      child: Container(
        color: color.withValues(alpha: 0.2), // تم الحل هنا
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 120),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSelection({required Key key}) {
    return Center(
      key: key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: const Icon(
                Icons.stars_rounded,
                size: 100,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'اختر مستوى الصعوبة يا نشمي',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 35),
            _levelButton('مبتدئ', Icons.child_care, Colors.green),
            _levelButton('متوسط', Icons.trending_up, Colors.orange),
            _levelButton('محترف', Icons.psychology, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _levelButton(String level, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: InkWell(
        onTap: () => setState(() {
          selectedLevel = level;
          currentQuestionIndex = 0;
          score = 0;
          quizFinished = false;
        }),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15), // تم الحل هنا
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 30),
              Expanded(
                child: Text(
                  level,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Icon(Icons.play_arrow_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizContent({required Key key}) {
    var questions = levelsQuestions[selectedLevel]!;
    var currentQ = questions[currentQuestionIndex];
    double progress = (currentQuestionIndex + 1) / 10;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      key: key,
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: progress,
            color: const Color(0xFFD4AF37),
            minHeight: 10,
          ),
          const SizedBox(height: 30),
          Text(
            'السؤال ${currentQuestionIndex + 1} من 10',
            style: const TextStyle(fontSize: 18, color: Color(0xFFD4AF37)),
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Text(
              currentQ['q'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(
            3,
            (index) =>
                _answerButton(index, currentQ['a'][index], currentQ['i']),
          ),
        ],
      ),
    );
  }

  Widget _answerButton(int index, String text, int correctIndex) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color btnColor = isDark ? Colors.white10 : Colors.white;
    Color textColor = isDark ? Colors.white : const Color(0xFF003366);

    if (lastSelectedAnswer != null) {
      if (index == correctIndex) {
        btnColor = Colors.green;
        textColor = Colors.white;
      } else if (index == lastSelectedAnswer) {
        btnColor = Colors.red;
        textColor = Colors.white;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: lastSelectedAnswer == null
              ? () => checkAnswer(index)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildResult({required Key key}) {
    return Center(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 120,
            color: Color(0xFFD4AF37),
          ),
          const SizedBox(height: 20),
          Text(
            score >= 5 ? 'كفو يا نشمي!' : 'تحتاج مراجعة يا بطل!',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text('نتيجتك: $score من 10', style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => setState(() => selectedLevel = null),
            icon: const Icon(Icons.refresh),
            label: const Text('تحدي جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
