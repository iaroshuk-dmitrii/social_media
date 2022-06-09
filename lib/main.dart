import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/business_logic/auth_bloc.dart';
import 'package:social_media/business_logic/login_cubit.dart';
import 'package:social_media/configuration/configuration.dart';
import 'package:social_media/repositories/auth_repository.dart';
import 'package:social_media/repositories/storage_repository.dart';
import 'package:social_media/ui/navigation.dart';
import 'package:social_media/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions.fromMap(Configuration.firebaseConfig),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final mainNavigation = MainNavigation();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (BuildContext context) => AuthRepository()),
        RepositoryProvider(create: (BuildContext context) => StorageRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider<LoginCubit>(create: (context) => LoginCubit(authRepository: context.read<AuthRepository>())),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          initialRoute: mainNavigation.initialRoute,
          routes: mainNavigation.routes,
          onGenerateRoute: mainNavigation.onGenerateRoute,
        ),
      ),
    );
  }
}
