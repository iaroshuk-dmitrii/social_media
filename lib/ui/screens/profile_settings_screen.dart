import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/business_logic/auth_bloc.dart';
import 'package:social_media/business_logic/image_picker_bloc.dart';
import 'package:social_media/business_logic/login_cubit.dart';
import 'package:social_media/business_logic/profile_settings_cubit.dart';
import 'package:social_media/ui/constants.dart';

class ProfileSettingsScreen extends StatelessWidget {
  static const String route = 'profile_screen';
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Center(child: Text('Настройки профиля')),
          actions: [
            IconButton(
              onPressed: () {
                //TODO
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _CircleAvatar(),
                const _SaveButton(),
                const _UsernameTextForm(),
                const _EmailTextForm(),
                const Expanded(child: SizedBox.shrink()),
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginCubit>().signOut();
                  },
                  style: whiteButtonStyle,
                  child: const Center(child: Text('Выйти')),
                ),
                const SizedBox(height: 25)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  const _CircleAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      BlocProvider.of<ImagePickerBloc>(context).add(ImagePickerResetEvent());
      if (state is AuthAuthenticatedState) {
        String? photo = state.user?.photoURL;
        return BlocBuilder<ImagePickerBloc, ImagePickerState>(builder: (context, state) {
          if (state is ImagePickerSelectedState) {
            return _Avatar(photoUrl: photo, photoFile: File(state.image.path));
          }
          return _Avatar(photoUrl: photo);
        });
      }
      return const _Avatar();
    });
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerBloc, ImagePickerState>(builder: (context, state) {
      if (state is ImagePickerSelectedState) {
        return TextButton(
          style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
          child: const Text(
            'Сохранить',
          ),
          onPressed: () {
            context.read<ProfileSettingsCubit>().updatePhoto(state.image);
          },
        );
      } else {
        return TextButton(
          style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
          child: const Text(
            'Сменить фото профиля',
          ),
          onPressed: () {
            BlocProvider.of<ImagePickerBloc>(context).add(ImagePickerSelectedEvent());
          },
        );
      }
    });
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;
  final File? photoFile;
  const _Avatar({Key? key, this.photoUrl, this.photoFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? photo;
    if (photoFile != null) {
      photo = FileImage(photoFile!);
    } else if (photoUrl != null) {
      photo = NetworkImage(photoUrl!);
    }
    //
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      radius: 40,
      foregroundImage: photo,
      child:
          (photoUrl == null && photoFile == null) ? const Icon(Icons.photo_camera, color: Colors.grey, size: 35) : null,
    );
  }
}

class _UsernameTextForm extends StatelessWidget {
  const _UsernameTextForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(builder: (context, state) {
      Widget? suffixButton;
      if (state.editingName == EditingName.isEditing) {
        suffixButton = TextButton(
          child: const Text('Сохранить'),
          onPressed: () {
            context.read<ProfileSettingsCubit>().saveName();
          },
        );
      }
      if (state.editingName == EditingName.saved) {
        suffixButton = TextButton(
          child: const Text('Изменить'),
          onPressed: () {
            context.read<ProfileSettingsCubit>().enableEditName();
          },
        );
      }
      return TextFormField(
        initialValue: state.user?.displayName,
        onChanged: (value) {
          context.read<ProfileSettingsCubit>().nameChanged(value);
        },
        readOnly: (state.editingName == EditingName.saved) ? true : false,
        decoration: InputDecoration(
          suffixIcon: suffixButton,
          labelText: 'Ваше имя',
        ),
      );
    });
  }
}

class _EmailTextForm extends StatelessWidget {
  const _EmailTextForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(builder: (context, state) {
      return TextFormField(
        initialValue: state.user?.email,
        readOnly: true,
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.lock_outlined),
          labelText: 'E-mail',
        ),
      );
    });
  }
}
