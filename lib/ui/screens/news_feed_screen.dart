import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/post_model.dart';
import 'package:jiffy/jiffy.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Center(child: Text('Лента'))),
        const _PostsList(),
      ],
    );
  }
}

class _PostsList extends StatelessWidget {
  const _PostsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const PostCard();
          }),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Post post = Post(
      userId: 'IdАвтора',
      id: 'IdПоста',
      imageUrl: 'https://as2.ftcdn.net/v2/jpg/04/74/45/89/1000_F_474458938_khsOT8d92ZtgGBCQMqWt6dGDtOEsUCk8.jpg',
      text: 'Текст поста',
      dateTime: DateTime(2022, 6, 15),
      likesUserId: ['1', '2'],
    );
    String username = 'Автор поста';
    String userImageUrl =
        'https://as2.ftcdn.net/v2/jpg/04/95/73/77/1000_F_495737712_q4azzYxmKUttTAWWDfKOEK4tFWtPbCnO.jpg';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundImage: NetworkImage(userImageUrl),
                ),
                const SizedBox(width: 10),
                Text(username),
                const Expanded(child: SizedBox.shrink()),
                Text(Jiffy(post.dateTime).fromNow()),
              ],
            ),
          ),
          (post.imageUrl != '')
              ? AspectRatio(
                  aspectRatio: 1.625,
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    placeholder: (context, url) => const ColoredBox(color: Colors.grey),
                    errorWidget: (context, url, error) => const ColoredBox(color: Colors.grey),
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25),
            child: Row(
              children: [
                const Icon(Icons.favorite_outline),
                Text('Нравится ${post.likesUserId.length}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 25, right: 25, bottom: 25),
            child: (post.text != '')
                ? Text(
                    post.text,
                    overflow: TextOverflow.ellipsis,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
