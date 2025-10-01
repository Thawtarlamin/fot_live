import '../exports.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  late String selectedLanguage;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = context.read<ThemeCubit>().state == ThemeMode.dark;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale.languageCode;
    setState(() {
      if (locale == 'en') {
        selectedLanguage = 'English';
      } else if (locale == 'my') {
        selectedLanguage = 'Myanmar';
      } else {
        selectedLanguage = 'English';
      }
    });
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cache cleared!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (val) {
                setState(() => isDarkMode = val);
                context.read<ThemeCubit>().toggleTheme();
              },
              secondary: const Icon(Icons.dark_mode, color: Colors.blue),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text('Notifications'),
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() => notificationsEnabled = val);
              },
              secondary: const Icon(Icons.notifications, color: Colors.orange),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text('Language'),
              subtitle: Text(selectedLanguage),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Myanmar', child: Text('Myanmar')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    if (val == 'English') {
                      context.setLocale(const Locale('en'));
                    } else if (val == 'Myanmar') {
                      context.setLocale(const Locale('my'));
                    }
                    setState(() => selectedLanguage = val);
                  }
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Clear Cache'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: clearCache,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.purple),
              title: const Text('Developer'),
              subtitle: const Text('IT Myanmar'),
            ),
          ),
        ],
      ),
    );
  }
}
