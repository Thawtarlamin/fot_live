import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/api_service.dart';
import '../ads_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_player/video_player.dart';

class StreamPlayerScreen extends StatefulWidget {
  final String matchId;
  const StreamPlayerScreen({Key? key, required this.matchId}) : super(key: key);

  @override
  _StreamPlayerScreenState createState() => _StreamPlayerScreenState();
}

class _StreamPlayerScreenState extends State<StreamPlayerScreen>
    with WidgetsBindingObserver {
  late Future<String> streamUrl;
  VideoPlayerController? _controller;
  final ApiService _apiService = ApiService();
  InterstitialAd? _interstitialAd;
  bool _isInterstitialShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    streamUrl = _apiService.fetchStreamUrl(widget.matchId);
    AdsManager.loadInterstitialAd();
    AdsManager.loadAppOpenAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      if (state == AppLifecycleState.resumed) {
        AdsManager.showAppOpenAd();
      }
    }
  }

  void _initVideo(String url) {
    if (_interstitialAd != null && !_isInterstitialShown) {
      _interstitialAd!.show();
      _isInterstitialShown = true;
    }
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Stream'.tr())),
      body: FutureBuilder<String>(
        future: streamUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \n${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Stream not available'));
          }
          final url = snapshot.data!;
          if (_controller == null) {
            _initVideo(url);
            return const Center(child: CircularProgressIndicator());
          }
          if (!_controller!.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          );
        },
      ),
    );
  }
}
