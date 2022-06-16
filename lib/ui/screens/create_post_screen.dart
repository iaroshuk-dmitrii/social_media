import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/business_logic/image_picker_bloc.dart';
import 'package:social_media/business_logic/main_tabs_bloc.dart';
import 'package:social_media/business_logic/post_cubit.dart';
import 'package:social_media/ui/constants.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Center(child: Text('Новый пост'))),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: const [
              _PostPhoto(),
              _PostBody(),
              _PostButton(),
              _ChangeScreenButton(),
            ],
          ),
        )),
      ],
    );
  }
}

class _PostPhoto extends StatelessWidget {
  const _PostPhoto({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ImagePickerBloc>(context).add(ImagePickerSelectedEvent());
      },
      child: AspectRatio(
        aspectRatio: 2.5,
        child: BlocListener<ImagePickerBloc, ImagePickerState>(
          listener: (context, state) {
            if (state is ImagePickerSelectedState) {
              context.read<PostCubit>().imageChanged(file: state.image);
            }
          },
          child: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
            DecorationImage? decorationImage;
            XFile? image = state.image;
            if (image != null && state.status != PostStatus.success) {
              decorationImage = DecorationImage(
                image: FileImage(File(image.path)),
                fit: BoxFit.cover,
              );
            }
            Widget? childWidget;
            if (state.status != PostStatus.success) {
              childWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 50,
                  ),
                  Text('Выбрать фото'),
                ],
              );
            } else {
              childWidget = Image.asset('assets/images/post_created.png');
            }
            return Container(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              foregroundDecoration: BoxDecoration(
                image: decorationImage,
                borderRadius: BorderRadius.circular(25.0),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: childWidget,
            );
          }),
        ),
      ),
    );
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      if (state.status != PostStatus.success) {
        return SizedBox(
          height: 100,
          child: TextField(
            onChanged: (value) {
              context.read<PostCubit>().textChanged(value);
            },
            decoration: const InputDecoration(
              labelText: 'Описание',
            ),
          ),
        );
      } else {
        return const SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text('Пост опубликован, теперь он находится в разделах “лента” и “профиль”'),
          ),
        );
      }
    });
  }
}

class _PostButton extends StatelessWidget {
  const _PostButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      switch (state.status) {
        case PostStatus.initial:
          return ElevatedButton(
            onPressed: null,
            style: whiteButtonStyle,
            child: const Center(child: Text('Опубликовать')),
          );
        case PostStatus.error:
        case PostStatus.readyForPost:
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [
                // Color(0xFF4138B4),
                Colors.deepPurpleAccent,
                Colors.blue,
              ]),
            ),
            child: ElevatedButton(
              onPressed: () {
                context.read<PostCubit>().createPost();
              },
              style: transparentButtonStyle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.flash_on,
                    color: Colors.amber,
                  ),
                  Text('Опубликовать'),
                ],
              ),
            ),
          );
        case PostStatus.inProgress:
          return ElevatedButton(
            onPressed: () {},
            style: blueButtonStyle,
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        case PostStatus.success:
          return ElevatedButton(
            onPressed: () {
              context.read<PostCubit>().resetState();
            },
            style: blueButtonStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.control_point_duplicate),
                Text('Сделать ещё публикацию'),
              ],
            ),
          );
      }
    });
  }
}

class _ChangeScreenButton extends StatelessWidget {
  const _ChangeScreenButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      if (state.status == PostStatus.success) {
        return TextButton(
          onPressed: () {
            context.read<PostCubit>().resetState();
            BlocProvider.of<MainTabsBloc>(context).add(ChangeTabEvent(0));
          },
          child: const Text('Перейти в ленту'),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
