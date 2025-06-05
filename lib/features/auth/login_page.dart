import 'package:flutter/material.dart';
import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/app/main_page.dart';
import 'package:LogisticsMasters/features/auth/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                child: Image.asset(
                  "assets/images/logo-blanco-turquesa.jpg",
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Let's Login!",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  cursorColor: ColorPalette.primaryColor,
                  decoration: InputDecoration(
                    hintText: "Enter Email Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: ColorPalette.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.email_outlined,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  obscureText: !_isVisible,
                  cursorColor: ColorPalette.primaryColor,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: ColorPalette.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isVisible ? Icons.visibility : Icons.visibility_off,
                        color: ColorPalette.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    },
                    child: Text('Sign In'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: ColorPalette.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
