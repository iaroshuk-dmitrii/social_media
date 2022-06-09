import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/business_logic/auth_bloc.dart';
import 'package:social_media/business_logic/login_cubit.dart';
import 'package:social_media/business_logic/main_tabs_bloc.dart';
import 'package:social_media/ui/navigation.dart';

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
          children: [
            Center(child: Text('Лента')),
            Center(child: Text('Новый пост')),
            Center(
                child: Column(
              children: [
                Text('Профиль'),
                TextButton(onPressed: () => context.read<LoginCubit>().signOut(), child: Text('Выйти'))
              ],
            )),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Лента',
              icon: Icon(Icons.credit_card),
              tooltip: 'Лента',
            ),
            BottomNavigationBarItem(
              label: 'Новый пост',
              icon: Icon(Icons.add_circle_outline),
              tooltip: 'Новый пост',
            ),
            BottomNavigationBarItem(
              label: 'Профиль',
              icon: Icon(Icons.image_outlined),
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
