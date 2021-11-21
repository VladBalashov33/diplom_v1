import 'package:diplom/models/user.dart';
import 'package:diplom/screens/detail_user/detail_user_screen.dart';
import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({
    required this.user,
    Key? key,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
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
          ),
          const Padding(padding: EdgeInsets.only(left: 8)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                style: Theme.of(context).textTheme.headline6,
              ),
              const Padding(padding: EdgeInsets.only(top: 4)),
              Text(
                user.name,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const Padding(padding: EdgeInsets.only(top: 2)),
              Text(
                'Подписчики: ${user.subscribers}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
