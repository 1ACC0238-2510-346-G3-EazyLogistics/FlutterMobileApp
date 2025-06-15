import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:LogisticsMasters/core/theme/color_palette.dart';
import 'package:LogisticsMasters/features/auth/presentation/pages/login_page.dart';
import 'package:LogisticsMasters/features/app/main_page.dart';
import 'package:LogisticsMasters/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:LogisticsMasters/features/auth/presentation/blocs/auth_event.dart';
import 'package:LogisticsMasters/features/auth/presentation/blocs/auth_state.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SuccessAuthState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(userName: state.user.name),
            ),
          );
        } else if (state is FailureAuthState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is LoadingAuthState;
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: AbsorbPointer(
                  absorbing: isLoading,
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
                          "Let's Register!",
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
                          controller: _firstNameController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "First name",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _lastNameController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Last name",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _emailController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Email",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _usernameController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Username",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Password",
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
                              Icons.lock_outline,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                RegisterEvent(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(color: ColorPalette.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
