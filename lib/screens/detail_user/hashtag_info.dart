import 'package:diplom/models/hashtag.dart';
import 'package:diplom/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HashtagInfo extends StatelessWidget {
  const HashtagInfo({
    required this.tag,
    Key? key,
  }) : super(key: key);

  final Hashtag tag;

  @override
  Widget build(BuildContext context) {
    final _border = BorderSide(
      color: AppColors.primary.withOpacity(0.8),
      width: 0.8,
      style: BorderStyle.solid,
    );
    return CustomExpansionTile(
      text: 'Основная информация',
      isExpand: true,
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(top: 16)),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              const TextSpan(text: 'Ссылка: '),
              TextSpan(
                text: tag.link,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.blueAccent,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch(tag.link);
                  },
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 366,
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
                  const CustomTitle(
                      'Количество постов с хештегом в инстаграме: '),
                  CustomText('${tag.mediaCount}'),
                ]),
                TableRow(children: [
                  const CustomTitle(
                      'Количество постов с хештегом у пользователя: '),
                  CustomText('${tag.mediaCount}'),
                ]),
              ],
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 4)),
      ],
    );
  }
}
