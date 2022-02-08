import 'package:diplom/models/user.dart';
import 'package:diplom/screens/detail_user/detail_user_screen.dart';
import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({
    required this.user,
    Key? key,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final _textStyle =
        Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailUserScreen(user: user),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          CachedImage(
            user.photo,
            height: 93,
            width: 113,
            alt: user.username.replaceAll('.', ''),
          ),
          const Padding(padding: EdgeInsets.only(left: 8)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: Theme.of(context).textTheme.headline6,
              ),
              const Padding(padding: EdgeInsets.only(top: 4)),
              Text(
                user.name,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
              const Padding(padding: EdgeInsets.only(top: 2)),
              Text(
                'Подписчики: ${user.subscribers}',
                style: _textStyle,
              ),
              const Padding(padding: EdgeInsets.only(top: 2)),
              Text(
                'Последняя активность: ${DateFormat.yMd().format(user.lastActivity!)}',
                style: _textStyle,
              ),
              const Padding(padding: EdgeInsets.only(top: 2)),
              Text(
                'Кол-во постов: ${user.countPublished}',
                style: _textStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
