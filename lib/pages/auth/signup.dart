import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_service.dart';
import '../home_page.dart'; // Adjust the path based on your project structure

class SignupUserPage extends StatefulWidget {
  const SignupUserPage({super.key});

  @override
  _SignupUserPageState createState() => _SignupUserPageState();
}

class _SignupUserPageState extends State<SignupUserPage> {
  final TextEditingController kundennummerController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isSignupEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    kundennummerController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    kundennummerController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isSignupEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          kundennummerController.text.isNotEmpty;
    });
  }

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final kundennummer = kundennummerController.text.trim();
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final error = await authService.signupUser(email, password, kundennummer);
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Registriere dich hier für den Kundenbereich.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Passwort',
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
              const SizedBox(height: 20),
              TextField(
                controller: kundennummerController,
                decoration: const InputDecoration(
                  labelText: 'Kundennummer',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSignupEnabled ? _signup : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Registrieren'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Handle navigation to login page here
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(
                        color: Color(0xFF012B56), // Border color
                        width: 1,           // Border width
                      ),
                    ),
                  ),
                  child: const Text(
                    'Bereits registriert? Einloggen',
                    style: TextStyle(
                      color: Color(0xFF012B56),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
