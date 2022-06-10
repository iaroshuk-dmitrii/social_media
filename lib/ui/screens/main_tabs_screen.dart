import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/business_logic/auth_bloc.dart';
import 'package:social_media/business_logic/main_tabs_bloc.dart';
import 'package:social_media/ui/navigation.dart';
import 'package:social_media/ui/screens/create_post_screen.dart';
import 'package:social_media/ui/screens/news_feed_screen.dart';
import 'package:social_media/ui/screens/profile_settings_screen.dart';

class MainTabsScreen extends StatelessWidget {
  const MainTabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = context.select((MainTabsBloc bloc) => bloc.state);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(Screens.login, (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: const [
            NewsFeedScreen(),
            CreatePostScreen(),
            ProfileSettingsScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Лента',
              icon: Icon(Icons.image_outlined),
              tooltip: 'Лента',
            ),
            BottomNavigationBarItem(
              label: 'Новый пост',
              icon: Icon(Icons.add_circle_outline),
              tooltip: 'Новый пост',
            ),
            BottomNavigationBarItem(
              label: 'Профиль',
              icon: Icon(Icons.person),
              tooltip: 'Профиль',
            ),
          ],
          onTap: (index) {
            context.read<MainTabsBloc>().add(ChangeTabEvent(index));
          },
        ),
      ),
    );
  }
}
