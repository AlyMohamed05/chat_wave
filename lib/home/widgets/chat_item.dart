import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/model/dm_channel.dart';
import 'package:chat_wave/home/screens/profile_picture_screen.dart';
import 'package:chat_wave/theme.dart';

import '../util/transparent_route.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.channel,
    this.onClick,
  });

  final Channel channel;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    TransparentRoute(
                      builder: (_) => ProfilePictureScreen(
                          heroTag: channel.id,
                          url: channel.imageUrl ??
                              'https://h-o-m-e.org/wp-content/uploads/2022/04/Blank-Profile-Picture-1.jpg'),
                    ),
                  ),
                  child: Hero(
                    tag: channel.id,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: CachedNetworkImageProvider(
                        channel.imageUrl ??
                            'https://h-o-m-e.org/wp-content/uploads/2022/04/Blank-Profile-Picture-1.jpg',
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 175),
                  width: channel is DmChannel && (channel as DmChannel).online
                      ? 20
                      : 0,
                  height: channel is DmChannel && (channel as DmChannel).online
                      ? 20
                      : 0,
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 10,
                  ),
                )
              ],
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          channel.name,
                          style: Theme.of(context).textTheme.displayMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (channel.lastMessage != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check, color: Colors.green),
                            const SizedBox(width: 4.0),
                            Text(
                              channel.lastMessage?.formattedDate ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        )
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  if (channel.lastMessage?.text != null)
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          if (channel.lastMessage?.isOwnMessage ?? false)
                            const TextSpan(
                              text: 'You: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGrey,
                              ),
                            ),
                          TextSpan(text: channel.lastMessage?.text),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
