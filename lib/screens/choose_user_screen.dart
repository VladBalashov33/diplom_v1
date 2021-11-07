import 'package:diplom/bloc/choose_user_bloc/choose_user_bloc.dart';
import 'package:diplom/models/user.dart';
import 'package:diplom/screens/detail_user_screen.dart';
import 'package:diplom/utils/constants.dart';
import 'package:diplom/widgets/bloc_provider_builder.dart';
import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseUserScreen extends StatelessWidget {
  const ChooseUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберете пользователя'),
      ),
      body: BlocProviderBuilder<ChooseUserBloc, ChooseUserState>(
        create: (context) => ChooseUserBloc(),
        builder: (context, state) {
          final users = context.watch<ChooseUserBloc>().users;
          return Stack(
            children: [
              ListView.separated(
                padding: Constants.listPadding,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _ListItem(user: users[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 16,
                    thickness: 1.5,
                  );
                },
              ),
              if (state is ChooseUserLoading) LoadingWidgets.loadingCenter(),
            ],
          );
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
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
