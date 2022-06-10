import 'package:flutter/material.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Center(child: Text('Лента'))),
        Flexible(child: Container()),
      ],
    );
  }
}
