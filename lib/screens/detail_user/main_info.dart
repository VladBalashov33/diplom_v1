import 'package:diplom/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainInfo extends StatelessWidget {
  const MainInfo({
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
    return CustomExpansionTile(
      text: 'Основная информация',
      children: <Widget>[
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
                  const CustomTitle('Приватный аккаунт: '),
                  CustomText('${user.isPrivet}'),
                ]),
                TableRow(children: [
                  const CustomTitle('Количество записей: '),
                  CustomText('${user.countPublished}'),
                ]),
                TableRow(children: [
                  const CustomTitle('Количество подписчиков: '),
                  CustomText('${user.subscribers}'),
                ]),
                TableRow(children: [
                  const CustomTitle('Подписан на: '),
                  CustomText('${user.countFollow}'),
                ]),
                TableRow(children: [
                  const CustomTitle('Последняя дата активности: '),
                  CustomText('${user.getLastActivityDate}'),
                ]),
                TableRow(children: [
                  const CustomTitle('Бизнес аккаунт: '),
                  CustomText('${user.isBusiness}'),
                ]),
                if (user.isBusiness)
                  TableRow(children: [
                    const CustomTitle('Категория бизнес аккаунта: '),
                    CustomText('${user.typeBusiness}'),
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
