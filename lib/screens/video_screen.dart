import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  // استخدام late فقط مع التأكد من التهيئة لمنع خطأ الـ Crash
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.asset(
        "assets/videos/jordan.mp4",
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        showControls: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFD4AF37),
          handleColor: const Color(0xFFD4AF37),
          backgroundColor: Colors.grey.withValues(
            alpha: 0.5,
          ), // التحديث الجديد بدلاً من withOpacity
          bufferedColor: Colors.white24,
        ),
        placeholder: Container(color: Colors.black),
        autoInitialize: true,
      );

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("خطأ في الفيديو: $e");
      if (mounted) setState(() => _isError = true);
    }
  }

  @override
  void dispose() {
    // التخلص من المتحكمات بشكل آمن
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'السينما السياحية',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.transparent : const Color(0xFF003366),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio:
                        (_videoPlayerController != null &&
                            _videoPlayerController!.value.isInitialized)
                        ? _videoPlayerController!.value.aspectRatio
                        : 16 / 9,
                    child: _buildPlayerBody(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerBody() {
    if (_isError) {
      return const Center(
        child: Text("تعذر تحميل الفيديو، تأكد من مسار الملف."),
      );
    }

    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return Chewie(controller: _chewieController!);
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFD4AF37)),
          SizedBox(height: 10),
          Text("جاري تهيئة السينما..."),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'رحلة عبر الأردن',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'استمتع بجولة بصرية مذهلة تبدأ من قلب عمان النابض وصولاً إلى سحر البحر الميت.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
