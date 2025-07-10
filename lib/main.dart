import 'package:LogisticsMasters/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:LogisticsMasters/features/discover/data/repositories/hotel_repository.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_bloc.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/search_bloc.dart';
import 'package:LogisticsMasters/features/favorites/data/repositories/favorite_hotel_repository.dart';
import 'package:LogisticsMasters/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:LogisticsMasters/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:LogisticsMasters/features/auth/data/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar GetStorage
  await UserRepository.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        BlocProvider<HotelBloc>(
          create: (context) => HotelBloc(
            repository: HotelRepository(),
          ),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
            repository: HotelRepository(),
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
