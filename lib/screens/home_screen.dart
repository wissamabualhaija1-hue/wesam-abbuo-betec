import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'places_screen.dart';
import 'quiz_screen.dart';
import 'video_screen.dart' as video_pkg;
import 'rating_screen.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('خدمة الموقع معطلة، يرجى تفعيل GPS');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('تم رفض إذن الوصول للموقع');
      }
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showContent = false;
  final LocationService _locationService = LocationService();
  final String localBackgroundImage = 'assets/images/back.jpg';

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _getUserLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'موقعك: ${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}',
            ),
          ),
          backgroundColor: const Color(0xFF003366),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text(e.toString())),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: !showContent ? _buildWelcome() : _buildDashboard(),
      ),
    );
  }

  Widget _buildWelcome() {
    return Container(
      key: const ValueKey(1),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(localBackgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37), width: 3),
              ),
              child: const Icon(
                Icons.explore_outlined,
                size: 90,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'الأردن.. ملتقى الحضارات',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'استكشف كنوز المملكة بلمسة واحدة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 70),
            _buildPrimaryButton(
              'ابدأ الرحلة',
              () => setState(() => showContent = true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      key: const ValueKey(2),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(localBackgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            isDark
                ? Colors.black.withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.92),
            BlendMode.srcOver,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'المستكشف السياحي',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.location_on,
              color: Color(0xFFD4AF37),
              size: 30,
            ),
            onPressed: _getUserLocation,
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark
                    ? Icons.wb_sunny_rounded
                    : Icons.nightlight_round_outlined,
              ),
              onPressed: () => widget.onThemeChanged(!isDark),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xFFD4AF37),
                  child: Icon(Icons.person_pin, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 15),
                const Text(
                  'أهلاً بك في أرض النشامى',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _buildSectionTitle('روابط سريعة (Visit Jordan)'),
                const SizedBox(height: 15),
                _buildCategoryRow(), // تم تعديل الويدجت الداخلي هنا
                const SizedBox(height: 35),
                _buildSectionTitle('الخدمات السياحية الأساسية'),
                const SizedBox(height: 10),
                _buildMenuCard(
                  'دليل الأقاليم',
                  'تصفح المعالم والمدن الأردنية',
                  Icons.map_rounded,
                  const PlacesScreen(),
                  const Color(0xFF003366),
                ),
                _buildMenuCard(
                  'تحدي المعرفة (كويز)',
                  'اختبر معلوماتك التاريخية',
                  Icons.psychology_alt_rounded,
                  const QuizScreen(),
                  const Color(0xFFB8860B),
                ),
                _buildMenuCard(
                  'السينما (فيديو JO)',
                  'مشاهد حصرية لجمال الأردن',
                  Icons.movie_filter_rounded,
                  const video_pkg.VideoScreen(),
                  const Color(0xFF003366),
                ),
                _buildMenuCard(
                  'قيم تجربتك',
                  'رأيك يهمنا لتطوير السياحة',
                  Icons.stars_rounded,
                  const RatingScreen(),
                  const Color(0xFFB8860B),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    String sub,
    IconData icon,
    Widget page,
    Color color,
  ) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 45),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        elevation: 8,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(width: 45, height: 3, color: const Color(0xFFD4AF37)),
      ],
    );
  }

  Widget _buildCategoryRow() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _categoryChip(
              'البتراء',
              'https://www.visitjordan.com/AR/Places_To_Go/Petra',
            ),
            _categoryChip(
              'وادي رم',
              'https://www.visitjordan.com/AR/Places_To_Go/Wadi_Rum',
            ),
            _categoryChip(
              'جرش',
              'https://www.visitjordan.com/AR/Places_To_Go/Jerash',
            ),
            _categoryChip(
              'العقبة',
              'https://www.visitjordan.com/AR/Places_To_Go/Aqaba',
            ),
          ],
        ),
      ),
    );
  }

  // الدالة التي تم تعديلها لحل مشكلة الـ Dark Mode
  Widget _categoryChip(String label, String url) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ActionChip(
        label: Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFD4AF37) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _launchURL(url),
        backgroundColor: isDark
            ? Colors.grey[900]?.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        side: const BorderSide(color: Color(0xFFD4AF37), width: 1.2),
        elevation: 2,
        shadowColor: Colors.black26,
      ),
    );
  }
}
