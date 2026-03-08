import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:audioplayers/audioplayers.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _userRating = 3.0;

  // 1. تعريف مشغل الصوت
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // اختياري: تهيئة المشغل ليكون مستعداً بأعلى صوت
    _audioPlayer.setVolume(1.0);
  }

  @override
  void dispose() {
    // إغلاق المشغل لتوفير الذاكرة
    _audioPlayer.dispose();
    super.dispose();
  }

  // 2. الدالة المعدلة والمضمونة لتشغيل صوت التصفيق
  Future<void> _playClapSound() async {
    try {
      // إيقاف أي صوت سابق فوراً
      await _audioPlayer.stop();

      // تشغيل الصوت. ملاحظة: لا نكتب 'assets/' في المسار داخل AssetSource
      // تأكد أن ملفك موجود في assets/sounds/clap.mp3
      await _audioPlayer.play(AssetSource('sounds/clap.mp3'));

      debugPrint("تم طلب تشغيل صوت التصفيق بنجاح");
    } catch (e) {
      debugPrint("خطأ في تشغيل صوت التصفيق: $e");
    }
  }

  Widget _getScoreEmoji() {
    // تم إضافة الأقواس المجعدة هنا لحل الـ Problems
    if (_userRating <= 1) {
      return const Text("😞", key: ValueKey(1), style: TextStyle(fontSize: 60));
    }
    if (_userRating <= 2) {
      return const Text("😐", key: ValueKey(2), style: TextStyle(fontSize: 60));
    }
    if (_userRating <= 3) {
      return const Text("😊", key: ValueKey(3), style: TextStyle(fontSize: 60));
    }
    if (_userRating <= 4) {
      return const Text("🤩", key: ValueKey(4), style: TextStyle(fontSize: 60));
    }
    return const Text("👑", key: ValueKey(5), style: TextStyle(fontSize: 60));
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('قيم تجربتك'),
        centerTitle: true,
        backgroundColor: isDark ? Colors.transparent : const Color(0xFF003366),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _getScoreEmoji(),
            ),
            const SizedBox(height: 20),
            Text(
              'رأيك يهمنا يا نشمي!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'تقييمك يساعدنا على تطوير تجربة السياحة في الأردن',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star_rounded, color: Color(0xFFD4AF37)),
              onRatingUpdate: (rating) {
                setState(() => _userRating = rating);
              },
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 200,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  _playClapSound(); // تشغيل الصوت فور الضغط
                  _showSuccessDialog(context);
                },
                child: const Text(
                  'إرسال التقييم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('شكراً لك!', textAlign: TextAlign.center),
        content: const Text(
          'تم استلام تقييمك بنجاح. نتمنى لك رحلة سعيدة في ربوع الوطن.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الديالوج
                Navigator.pop(context); // العودة للصفحة السابقة
              },
              child: const Text(
                'حياك الله',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
