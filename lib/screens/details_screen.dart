import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailsScreen extends StatelessWidget {
  final String placeName;
  final String imagePath;

  const DetailsScreen({
    super.key,
    required this.placeName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الثيم لضبط ألوان النصوص (اختياري لو أردت دعم الدارك مود هنا)
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          placeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // توسيط العنوان في الـ AppBar
        backgroundColor: const Color(0xFF003366), // الكحلي الملكي
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          // لضمان توسيط العناصر في الشاشة
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // عرض صورة المعلم بتصميم فخم
              Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // العنوان الرئيسي
              Text(
                'تفاصيل $placeName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // الوصف الموسط
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'استكشف جمال عراقة الماضي في $placeName، حيث التاريخ يلتقي بالحاضر ليروي قصة الأردن ملتقى الحضارات.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 17,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // زر الفيديو الموسط
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    // الانتقال لصفحة الفيديو
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoScreen()));
                  },
                  icon: const Icon(Icons.play_circle_filled_rounded, size: 28),
                  label: const Text(
                    'شاهد الفيديو التعريفي',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // قسم التقييم الحديث
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ما هو تقييمك لهذه التجربة؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    const SizedBox(height: 15),
                    RatingBar.builder(
                      initialRating: 4.5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFD4AF37),
                      ),
                      onRatingUpdate: (rating) {
                        // حفظ التقييم هنا
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
