import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_service.dart';
import '../sharedUI/guest_ui.dart';
import '../sharedUI/user_ui.dart';
import '../widgets/my_card.dart';
import 'profile_details_screen.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../helpers/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? greetingText;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }


  Future<void> _loadUserProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userData = await authService.fetchUserData();

    if (userData != null) {
      final role = userData['role'] ?? 'guest';
      final firstName = userData['general']?['firstName'] ?? '';
      final lastName = userData['general']?['lastName'] ?? '';

      setState(() {
        if (role == 'guest') {
          greetingText = AppLocalizations.of(context).translate('greeting_guest');
        } else {
          greetingText = firstName.isNotEmpty && lastName.isNotEmpty
              ? AppLocalizations.of(context).translate('greeting_user', {'firstName': firstName, 'lastName': lastName})
              : AppLocalizations.of(context).translate('greeting_default');
        }
      });
    } else {
      setState(() {
        greetingText = AppLocalizations.of(context).translate('greeting_guest');
      });
    }
  }

  Future<void> _confirmAndLogout() async {
    final shouldLogout = await _showConfirmationDialog(
        AppLocalizations.of(context).translate('logout'),
        AppLocalizations.of(context).translate('confirm_logout'));
    if (shouldLogout) {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logout(context);
    }
  }

  Future<void> _confirmAndDeleteAccount() async {
    final shouldDelete = await _showConfirmationDialog(
        AppLocalizations.of(context).translate('delete_account'),
        AppLocalizations.of(context).translate('confirm_delete_account'));
    if (shouldDelete) {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.deleteUser(context);
    }
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).translate('confirm')),
          ),
        ],
      ),
    )) ??
        false;
  }

  void _navigateBasedOnRole(BuildContext context, String userRole) {
    if (userRole == 'user') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserUIPage()),
      );
    } else if (userRole == 'guest') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GuestUIPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return FutureBuilder<String?>(
      future: authService.fetchUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(child: Text(AppLocalizations.of(context).translate('error_fetching_role'))),
          );
        }

        final userRole = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate('profile_title')),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greetingText ?? AppLocalizations.of(context).translate('loading_text'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyCard(
                    icon: Icons.pedal_bike_outlined,
                    text: AppLocalizations.of(context).translate('my_bikes'),
                    onTap: () {
                      _navigateBasedOnRole(context, userRole!);
                    },
                  ),
                  const SizedBox(height: 10),
                  MyCard(
                    icon: Icons.person_outline,
                    text: AppLocalizations.of(context).translate('personal_data'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  MyCard(
                    icon: Icons.file_copy_outlined,
                    text: AppLocalizations.of(context).translate('my_contracts'),
                    onTap: () {
                      _navigateBasedOnRole(context, userRole!);
                    },
                  ),
                  const SizedBox(height: 10),
                  MyCard(
                    icon: Icons.star_border,
                    text: AppLocalizations.of(context).translate('my_favorites'),
                    onTap: () {
                      _navigateBasedOnRole(context, userRole!);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Updated Row containing theme toggle and language dropdown
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
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: 'de',
                                child: Text('Deutsch'),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              // Add more languages if needed
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                languageProvider.setLanguage(newValue);
                                _loadUserProfile();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
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
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _confirmAndLogout,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, color: Colors.purple),
                              const SizedBox(width: 15),
                              Text(AppLocalizations.of(context).translate('logout')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context).translate('delete_account_text'),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              const TextSpan(
                                text: ' ', // Adding space between the two texts
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context).translate('delete_account'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _confirmAndDeleteAccount,
                              ),
                              const TextSpan(
                                text: '.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
