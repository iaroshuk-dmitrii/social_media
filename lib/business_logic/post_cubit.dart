import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/repositories/auth_repository.dart';
import 'package:social_media/repositories/storage_repository.dart';
import 'package:social_media/repositories/store_repository.dart';
import 'package:uuid/uuid.dart';

class PostCubit extends Cubit<PostState> {
  final StoreRepository _storeRepository;
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  final uuid = const Uuid();

  PostCubit({
    required StoreRepository storeRepository,
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _storeRepository = storeRepository,
        _authRepository = authRepository,
        _storageRepository = storageRepository,
        super(PostState(
          id: '',
          text: '',
          dateTime: DateTime.now(),
          status: PostStatus.initial,
          error: '',
          post: null,
          image: null,
        ));

  void textChanged(String value) {
    print('textChanged $value');
    emit(state.copyWith(text: value));
    _checkStatus();
  }

  Future<void> imageChanged({XFile? file}) async {
    print('imageChanged ');
    emit(state.copyWith(image: file));
    _checkStatus();
  }

  void resetState() {
    print('resetState');
    emit(PostState(
      id: '',
      text: '',
      dateTime: DateTime.now(),
      status: PostStatus.initial,
      error: '',
      post: null,
      image: null,
    ));
  }

  Future<void> createPost() async {
    print('createPost');
    emit(state.copyWith(status: PostStatus.inProgress));
    try {
      User? user = await _authRepository.getCurrentUser();
      if (user != null && (state.text != '' || state.image != null)) {
        String imageUrl = '';
        if (state.image != null) {
          String imageName = '${user.uid}-${uuid.v4()}';
          imageUrl = await _storageRepository.uploadFile(
                folderName: 'posts/',
                file: state.image!,
                newFileName: '$imageName.jpg',
              ) ??
              '';
        }
        Post post = Post(
            id: state.id,
            userId: user.uid,
            text: state.text,
            imageUrl: imageUrl,
            dateTime: state.dateTime,
            likesUserId: []);
        await _storeRepository.addPost(post: post);
        emit(state.copyWith(status: PostStatus.success));
      }
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: PostStatus.error, error: e.toString()));
    }
  }

  Future<void> deletePost(Post post) async {
    print('deletePost');
    emit(state.copyWith(status: PostStatus.inProgress));
    try {
      if (post.imageUrl != '') {
        await _storageRepository.deleteFile(url: post.imageUrl);
      }
      await _storeRepository.deletePost(post: post);
      emit(state.copyWith(status: PostStatus.success));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: PostStatus.error, error: e.toString()));
    }
  }

  void _checkStatus() {
    if (state.image != null || state.text != '') {
      emit(state.copyWith(status: PostStatus.readyForPost));
    } else {
      emit(state.copyWith(status: PostStatus.initial));
    }
  }
}

//------------------------------
enum PostStatus { initial, readyForPost, inProgress, success, error }

//------------------------------
class PostState {
  final String id;
  final String text;
  final DateTime dateTime;
  final PostStatus status;
  final String error;
  final Post? post;
  final XFile? image;

  const PostState({
    required this.id,
    required this.text,
    required this.dateTime,
    required this.status,
    required this.error,
    this.post,
    this.image,
  });

  PostState copyWith({
    String? id,
    String? text,
    DateTime? dateTime,
    PostStatus? status,
    String? error,
    Post? post,
    XFile? image,
  }) {
    return PostState(
      id: id ?? this.id,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      error: error ?? this.error,
      post: post ?? this.post,
      image: image ?? this.image,
    );
  }
}
