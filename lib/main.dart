import 'package:LogisticsMasters/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:LogisticsMasters/features/favorites/data/repositories/favorite_hotel_repository.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(
            repository: FavoriteHotelRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        home: const Scaffold(body: LoginPage()),
      ),
    );
  }
}
