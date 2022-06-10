import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Center(child: Text('Новый пост'))),
        Flexible(child: Container()),
      ],
    );
  }
}
