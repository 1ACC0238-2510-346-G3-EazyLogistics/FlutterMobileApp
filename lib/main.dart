import 'package:LogisticsMasters/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/features/auth/presentation/auth_flow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (context) => AuthBloc())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: AuthFlow()),
      ),
    );
  }
}
