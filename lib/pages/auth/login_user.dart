import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../providers/auth_service.dart';
import '../home_page.dart';
import 'signup.dart';

class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  _LoginUserPageState createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController forgotPasswordEmailController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoginEnabled = false;
  bool _isForgotPasswordMode = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    forgotPasswordEmailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isLoginEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final authService = Provider.of<AuthService>(context, listen: false);

    final error = await authService.loginUser(email, password);
    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _resetPassword() async {
    final email = forgotPasswordEmailController.text.trim();
    final authService = Provider.of<AuthService>(context, listen: false);

    final error = await authService.forgotPassword(email);
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('reset_password_message'))),
      );
      setState(() {
        _isForgotPasswordMode = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('login_title')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isForgotPasswordMode) ...[
                Text(
                  localizations.translate('login_message'),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: localizations.translate('email'),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: localizations.translate('password'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isForgotPasswordMode = true;
                    });
                  },
                  child: Text(
                    localizations.translate('forgot_password'),
                    style: const TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoginEnabled ? _login : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(localizations.translate('login_button')),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupUserPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Color(0xFF012B56),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      localizations.translate('signup_button'),
                      style: const TextStyle(color: Color(0xFF012B56)),
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  localizations.translate('reset_password_message'),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: forgotPasswordEmailController,
                  decoration: InputDecoration(
                    labelText: localizations.translate('email'),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(localizations.translate('reset_password_button')),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isForgotPasswordMode = false;
                    });
                  },
                  child: Text(localizations.translate('back_to_login')),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
