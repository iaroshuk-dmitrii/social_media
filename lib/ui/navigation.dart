import 'package:flutter/material.dart';
import 'package:social_media/ui/screens/loader_screen.dart';

abstract class Screens {
  static const loader = '/LoaderScreen';
  static const login = '/LoginScreen';
  static const mainTabs = '/MainTabsScreen';
}

class MainNavigation {
  final initialRoute = Screens.loader;

  final routes = <String, Widget Function(BuildContext)>{
    Screens.loader: (context) {
      print('Create LoaderScreen');
      return const LoaderScreen();
    },
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(builder: (context) => const Text('Navigation Error!!'));
    }
  }
}