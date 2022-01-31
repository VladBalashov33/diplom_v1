import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';

class UserTitle extends StatelessWidget {
  const UserTitle({
    required this.user,
    Key? key,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedImage(
          user.photo,
          height: 168,
          width: 204,
        ),
        const Padding(padding: EdgeInsets.only(left: 8)),
        SizedBox(
          width: MediaQuery.of(context).size.width - 204 - 8 - 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Имя пользователя: ${user.username}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              Text(
                'Полное имя: ${user.name}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
