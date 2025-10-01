import '../exports.dart';
import '../ads_manager.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _nativeAd = AdsManager.createNativeAd(
      onLoaded: (ad) {
        setState(() {
          _isNativeAdLoaded = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.sports_soccer,
                  size: 40,
                  color: Colors.green,
                ),
                title: Text(
                  'Live Football'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Version: 1.0.0'.tr()),
                    Text('Developer: IT Myanmar'.tr()),
                    Text('Contact: itmyanmar.dev@gmail.com'.tr()),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'This app provides live football match information, streaming links, and more. Designed for fans to easily follow their favorite teams and leagues.'
                      .tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  '© 2025 IT Myanmar. All rights reserved.'.tr(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.star_rate, color: Colors.amber),
                title: Text('Rate on Play Store'.tr()),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.example.yourapp',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text('Rate'.tr()),
                ),
              ),
            ),
            if (_isNativeAdLoaded)
              Card(
                child: SizedBox(height: 100, child: AdWidget(ad: _nativeAd!)),
              ),
          ],
        ),
      ),
    );
  }
}
