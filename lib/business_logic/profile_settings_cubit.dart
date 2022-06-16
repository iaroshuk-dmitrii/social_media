import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/repositories/auth_repository.dart';
import 'package:social_media/repositories/storage_repository.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  StreamSubscription<User?>? _userSubscription;

  ProfileSettingsCubit({
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _authRepository = authRepository,
        _storageRepository = storageRepository,
        super(ProfileSettingsState(
          user: null,
          username: '',
          editingName: EditingName.empty,
        ));

  void subscribe() {
    print('ProfileSettingsCubit: subscribe');
    _userSubscription = _authRepository.user.listen((user) {
      _onUserChanged(user);
    });
  }

  void _onUserChanged(User? user) {
    print('ProfileSettingsCubit: _onProfileChanged');
    if (user?.displayName == null || user?.displayName == '') {
      emit(state.copyWith(user: user, editingName: EditingName.empty));
    } else {
      emit(state.copyWith(user: user, editingName: EditingName.saved));
    }
  }

  void updatePhoto(XFile file) async {
    print('ProfileSettingsCubit: updatePhoto');
    if (state.user != null) {
      String? photoURL = await _storageRepository.uploadFile(
        folderName: 'users/${state.user!}/',
        file: file,
        newFileName: 'avatar.jpg',
      );
      if (photoURL != null) {
        await _authRepository.changePhotoUrl(photoURL: photoURL);
      }
    }
  }

  void enableEditName() {
    print('ProfileSettingsCubit: enableEditName');
    emit(state.copyWith(editingName: EditingName.isEditing));
  }

  void nameChanged(String value) {
    print('ProfileSettingsCubit: nameChanged');
    emit(state.copyWith(username: value, editingName: EditingName.isEditing));
  }

  void saveName() async {
    print('ProfileSettingsCubit: saveName');
    await _authRepository.changeUsername(username: state.username);
    emit(state.copyWith(editingName: EditingName.saved));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

enum EditingName { empty, isEditing, saved }

//------------------------------
class ProfileSettingsState {
  final User? user;
  final String username;
  EditingName editingName;

  ProfileSettingsState({
    this.user,
    required this.username,
    required this.editingName,
  });

  ProfileSettingsState copyWith({
    User? user,
    String? username,
    EditingName? editingName,
  }) {
    return ProfileSettingsState(
      user: user ?? this.user,
      username: username ?? this.username,
      editingName: editingName ?? this.editingName,
    );
  }
}
