import 'package:diplom/bloc/choose_user_bloc/choose_user_bloc.dart';
import 'package:diplom/models/user.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailUserScreen extends StatelessWidget {
  final User user;
  const DetailUserScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<User>.value(
      value: user,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.username),
        ),
        body: BlocProviderBuilder<ChooseUserBloc, ChooseUserState>(
          create: (context) => ChooseUserBloc(),
          builder: (context, state) {
            return Stack(
              children: [
                const _Body(),
                if (state is ChooseUserLoading) LoadingWidgets.loadingCenter(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    final _border = BorderSide(
      color: AppColors.primary.withOpacity(0.8),
      width: 0.8,
      style: BorderStyle.solid,
    );
    return ListView(
      padding: Constants.listPadding,
      children: [
        Row(
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
        ),
        const Padding(padding: EdgeInsets.only(top: 16)),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              const TextSpan(text: 'Ссылка: '),
              TextSpan(
                text: user.url,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.blueAccent,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(user.url);
                  },
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 336,
            child: Table(
              border: TableBorder(
                horizontalInside: _border,
                bottom: _border,
              ),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(children: [
                  const _Title('Приватный аккаунт: '),
                  _Text('${user.isPrivet}'),
                ]),
                TableRow(children: [
                  const _Title('Количество записей: '),
                  _Text('${user.countPublished}'),
                ]),
                TableRow(children: [
                  const _Title('Количество подписчиков: '),
                  _Text('${user.subscribers}'),
                ]),
                TableRow(children: [
                  const _Title('Подписан на: '),
                  _Text('${user.countFollow}'),
                ]),
                TableRow(children: [
                  const _Title('Последняя дата активности: '),
                  _Text('${user.getLastActivityDate}'),
                ]),
                TableRow(children: [
                  const _Title('Бизнес аккаунт: '),
                  _Text('${user.isBusiness}'),
                ]),
                if (user.isBusiness)
                  TableRow(children: [
                    const _Title('Категория бизнес аккаунта: '),
                    _Text('${user.typeBusiness}'),
                  ]),
              ],
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              const TextSpan(text: 'Описание аккаунта: '),
              TextSpan(
                text: ' ${user.description}',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      height: 1.8,
                    ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              const TextSpan(text: 'Внешние ссылки:\n'),
              ...user.alsoUrl
                  .map(
                    (e) => TextSpan(
                      text: '$e\n',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.blueAccent,
                            height: 1.8,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(user.url);
                        },
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(
    this.title, {
    Key? key,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.8),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8),
    );
  }
}
