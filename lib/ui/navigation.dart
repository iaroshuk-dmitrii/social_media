import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_media/ui/screens/loader_screen.dart';
import 'package:social_media/ui/screens/login_screen.dart';
import 'package:social_media/ui/screens/main_tabs_screen.dart';

abstract class Screens {
  static const loader = 'LoaderScreen';
  static const login = 'LoginScreen';
  static const mainTabs = 'MainTabsScreen';
}

class MainNavigation {
  final initialRoute = Screens.loader;

  final routes = <String, Widget Function(BuildContext)>{
    Screens.loader: (context) {
      log('Create LoaderScreen');
      return const LoaderScreen();
    },
    Screens.login: (context) {
      log('Create LoginScreen');
      return const LoginScreen();
    },
    Screens.mainTabs: (context) {
      log('Create MainTabsScreen');
      return const MainTabsScreen();
    },
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(builder: (context) => const Text('Navigation Error!!'));
    }
  }
}
