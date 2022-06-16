import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/business_logic/auth_bloc.dart';
import 'package:social_media/business_logic/image_picker_bloc.dart';
import 'package:social_media/business_logic/login_cubit.dart';
import 'package:social_media/business_logic/main_tabs_bloc.dart';
import 'package:social_media/business_logic/post_cubit.dart';
import 'package:social_media/business_logic/profile_settings_cubit.dart';
import 'package:social_media/repositories/auth_repository.dart';
import 'package:social_media/repositories/storage_repository.dart';
import 'package:social_media/repositories/store_repository.dart';
import 'package:social_media/ui/navigation.dart';
import 'package:social_media/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        RepositoryProvider(create: (BuildContext context) => StoreRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider<LoginCubit>(create: (context) => LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider<MainTabsBloc>(create: (context) => MainTabsBloc()),
          BlocProvider<ImagePickerBloc>(create: (context) => ImagePickerBloc()),
          BlocProvider<ProfileSettingsCubit>(
            create: (context) => ProfileSettingsCubit(
                authRepository: context.read<AuthRepository>(), storageRepository: context.read<StorageRepository>())
              ..subscribe(),
            lazy: false,
          ),
          BlocProvider<PostCubit>(
              create: (context) => PostCubit(
                  authRepository: context.read<AuthRepository>(),
                  storeRepository: context.read<StoreRepository>(),
                  storageRepository: context.read<StorageRepository>())),
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
