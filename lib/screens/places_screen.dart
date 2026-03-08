import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // تأكد من وجود هذه المكتبة

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  // تم إضافة 'lat' و 'lng' لكل موقع لتحقيق معيار الـ GPS
  final Map<String, List<Map<String, String>>> regionalPlaces = const {
    'إقليم الشمال': [
      {
        'name': 'مدينة جرش الأثرية',
        'img': 'assets/images/jarash.jpg',
        'full_desc':
            'تعتبر جرش من أفضل المدن الرومانية المحفوظة في العالم. تُعرف بمدينة "الألف عمود". تضم معالم بارزة مثل شارع الأعمدة والمسارح الكبيرة.',
        'lat': '32.2723',
        'lng': '35.8914',
      },
      {
        'name': 'قلعة عجلون',
        'img': 'assets/images/3ajloon.jpg',
        'full_desc':
            'بناها القائد عز الدين أسامة أحد قادة صلاح الدين الأيوبي عام 1184م لتكون حصناً منيعاً في وجه الهجمات الصليبية.',
        'lat': '32.3328',
        'lng': '35.7516',
      },
    ],
    'إقليم الوسط': [
      {
        'name': 'المدرج الروماني',
        'img': 'assets/images/roman.jpg',
        'full_desc':
            'يقع في قلب العاصمة عمان، وهو مسرح روماني كبير يعود للقرن الثاني الميلادي. يتسع لحوالي 6000 متفرج.',
        'lat': '31.9513',
        'lng': '35.9392',
      },
      {
        'name': 'البحر الميت',
        'img': 'assets/images/bahr.jpg',
        'full_desc':
            'أخفض نقطة على سطح الأرض. يمتاز بمياهه شديدة الملوحة التي تمنح الجسم فوائد علاجية وتسمح بالطفو بسهولة.',
        'lat': '31.5000',
        'lng': '35.5000',
      },
    ],
    'إقليم الجنوب': [
      {
        'name': 'البتراء',
        'img': 'assets/images/batra.jpg',
        'full_desc':
            'عاصمة الأنباط القديمة، منحوتة في الصخور الوردية. إحدى عجائب الدنيا السبع الجديدة.',
        'lat': '30.3285',
        'lng': '35.4444',
      },
      {
        'name': 'وادي رم',
        'img': 'assets/images/wadi.jpg',
        'full_desc':
            'يمتاز بطبيعته الصحراوية الخلابة ورماله الحمراء وجباله الصخرية الشاهقة. هو المكان المثالي لرؤية النجوم.',
        'lat': '29.5735',
        'lng': '35.4210',
      },
    ],
    'إقليم الشرق': [
      {
        'name': 'قصر الأمراء',
        'img': 'assets/images/qasr.jpg',
        'full_desc':
            'يُعرف أيضاً بقصر عراق الأمير، وهو معلم تاريخي فريد يجمع بين الحضارة الهلنستية واللمسات المحلية في وادي السير.',
        'lat': '31.9125',
        'lng': '35.7500',
      },
    ],
  };

  // دالة لفتح الخرائط
  Future<void> _openMap(String lat, String lng) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'دليل الأقاليم الأردنية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Color(0xFFD4AF37),
            labelColor: Color(0xFFD4AF37),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'الشمال', icon: Icon(Icons.terrain)),
              Tab(text: 'الوسط', icon: Icon(Icons.location_city)),
              Tab(text: 'الجنوب', icon: Icon(Icons.auto_awesome)),
              Tab(text: 'الشرق', icon: Icon(Icons.wb_sunny)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRegionList(context, 'إقليم الشمال'),
            _buildRegionList(context, 'إقليم الوسط'),
            _buildRegionList(context, 'إقليم الجنوب'),
            _buildRegionList(context, 'إقليم الشرق'),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionList(BuildContext context, String regionName) {
    final places = regionalPlaces[regionName] ?? [];
    return ListView.builder(
      itemCount: places.length,
      padding: const EdgeInsets.all(15),
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                places[index]['img']!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 40),
              ),
            ),
            title: Text(
              places[index]['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFD4AF37),
            ),
            onTap: () => _showDetails(context, places[index]),
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context, Map<String, String> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        height:
            MediaQuery.of(context).size.height *
            0.8, // زدت الطول شوي عشان الزر الجديد
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  place['img']!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                place['name']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(height: 15),
              // أيقونة اللوكيشن تحت الاسم مباشرة
              IconButton(
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
                onPressed: () => _openMap(place['lat']!, place['lng']!),
              ),
              const Text(
                "اضغط لعرض الموقع على الخريطة",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              Text(
                place['full_desc']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, height: 1.6),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'فهمت، شكراً',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
