import '../exports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperOptionsScreen extends StatefulWidget {
  const DeveloperOptionsScreen({Key? key}) : super(key: key);

  @override
  State<DeveloperOptionsScreen> createState() => _DeveloperOptionsScreenState();
}

class _DeveloperOptionsScreenState extends State<DeveloperOptionsScreen> {
  String? debugInfo;
  bool showDebugBanner = true;

  Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      debugInfo = 'SharedPreferences cleared!';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text('Developer Options'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette, color: Colors.blue),
                title: Text('${'Theme Mode:'.tr()} $themeMode'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text('Clear SharedPreferences'.tr()),
                trailing: ElevatedButton(
                  onPressed: clearPrefs,
                  child: Text('Clear'.tr()),
                ),
                subtitle: debugInfo != null ? Text(debugInfo!) : null,
              ),
            ),
            Card(
              child: SwitchListTile(
                title: Text('Show Debug Banner'.tr()),
                value: showDebugBanner,
                onChanged: (val) {
                  setState(() {
                    showDebugBanner = val;
                  });
                },
                secondary: const Icon(Icons.bug_report, color: Colors.orange),
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
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.list_alt, color: Colors.green),
                title: Text(
                  'Used Packages',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                children: [
                  ...[
                    'easy_localization',
                    'flutter_bloc',
                    'google_mobile_ads',
                    'in_app_update',
                    'url_launcher',
                  ].map(
                    (pkg) => ListTile(
                      leading: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      title: Text(pkg),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
