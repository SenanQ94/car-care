import 'package:flutter/material.dart';
import 'package:linexo_demo/pages/auth/login_guest.dart';
import 'package:linexo_demo/pages/auth/login_user.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                child: Image.asset(
                    themeProvider.isDarkMode
                        ? 'assets/images/logo-neg.png'
                        : 'assets/images/logo.png',
                    height: 120,
                    semanticLabel: localizations.translate('logo_alt_text')),
              ),
              LoginCard(
                title: localizations.translate('login_user_title'),
                icon: Icons.account_circle,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginUserPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              LoginCard(
                title: localizations.translate('login_guest_title'),
                icon: Icons.account_circle_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginAsGuestPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language_outlined),
                      title: DropdownButton<String>(
                        value: languageProvider.locale.languageCode,
                        underline: Container(),
                        isExpanded: false,
                        items: const [
                          DropdownMenuItem(
                            value: 'de',
                            child: Text('Deutsch'),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('English'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            languageProvider.setLanguage(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(AppLocalizations.of(context).translate('dark_mode')),
                      trailing: IconButton(
                        icon: Icon(themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode),
                        onPressed: () => themeProvider.toggleTheme(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const LoginCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Icon(icon, size: 20),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
