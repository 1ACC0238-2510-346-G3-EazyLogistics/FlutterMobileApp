import 'package:LogisticsMasters/features/auth/presentation/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'role_selection_page.dart';

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/admin':
            page = RegistrationPage(isAdmin: true);
            break;
          case '/user':
            page = const RegistrationPage();
            break;
          case '/':
          default:
            page = RoleSelectionPage(
              onUserSelected: () {
                navigatorKey.currentState?.pushNamed('/user');
              },
              onAdminSelected: () {
                navigatorKey.currentState?.pushNamed('/admin');
              },
            );
            break;
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
