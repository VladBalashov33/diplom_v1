import 'package:diplom/bloc/choose_user_bloc/choose_user_bloc.dart';
import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/screens/links_screen.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/calendar.dart';
import 'package:diplom/widgets/charts/chart_day_post.dart';
import 'package:diplom/widgets/charts/chart_like_count.dart';
import 'package:diplom/widgets/charts/chart_user_count.dart';
import 'package:diplom/widgets/html_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'main_info.dart';
import 'user_title.dart';

class DetailUserScreen extends StatelessWidget {
  final User user;
  const DetailUserScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalKey<ScaffoldState>>.value(
      value: scaffoldKey,
      child: BlocProviderConsumer<DetailUserBloc, DetailUserState>(
        listener: (context, state) {
          if (state is DetailUserDelete) {
            context.read<ChooseUserBloc>().getUsers();
            Navigator.of(context).pop();
          }
        },
        create: (context) => DetailUserBloc(user.id),
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            drawerScrimColor: Colors.transparent,
            endDrawer: const _Drawer(),
            appBar: AppBar(
              title: Text(user.username),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: state is DetailUserLoading
                ? LoadingWidgets.loadingCenter()
                : const _Body(),
          );
        },
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
    final _posts = context.watch<DetailUserBloc>().posts;

    return ListView(
      padding: Constants.listPadding,
      children: [
        const UserTitle(),
        MainInfo(user: context.watch<DetailUserBloc>().user),

        const _HelpText(),
        CustomExpansionTile(
          text: 'Постов в месяц',
          children: <Widget>[
            ChartDayPost(
              data: _posts.postPerPeriod(DateType.month),
              dateFormat: DateFormat.MMM(),
            )
          ],
        ),
        CustomExpansionTile(
          text: 'Постов в день',
          children: <Widget>[
            ChartDayPost(data: _posts.postPerPeriod(DateType.day))
          ],
        ),
        CustomExpansionTile(
          text: 'Постов в течении дня',
          children: <Widget>[ChartAmongDayPost(data: _posts.postAmongDay())],
        ),
        // CustomExpansionTile(
        //   text: 'Количество коммерческих постов',
        //   children: <Widget>[ChartTrueFalse(data: _posts.isCommercialData)],
        // ),

        CustomExpansionTile(
          text: 'Количество лайков в постах',
          children: <Widget>[
            ChartLikeCount(
              data: _posts.likeCountByPostData,
              title: 'лайки',
            )
          ],
        ),
        CustomExpansionTile(
          text: 'Количество комментариев в постах',
          children: <Widget>[
            ChartLikeCount(
              data: _posts.commentCountByPostData,
              title: 'комментарии',
            )
          ],
        ),

        CustomExpansionTile(
          text: hashtag[0],
          children: <Widget>[
            ChartUserCount(
              data: _posts.getTagsChartData,
              text: hashtag,
            )
          ],
        ),
        CustomExpansionTile(
          text: friends[0],
          children: <Widget>[
            ChartUserCount(
              data: _posts.getFriendsChartData,
              text: friends,
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 200)),
        const SafeArea(top: false, child: SizedBox()),
      ],
    );
  }
}

void toListLinks(
  BuildContext context,
  List<String> links, {
  String? name,
  bool isHashtag = false,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<DetailUserBloc>(),
        child: LinksScreen(
          postLinks: links,
          name: name,
          isHashtag: isHashtag,
        ),
      ),
    ),
  );
}

class _Switchers extends StatefulWidget {
  const _Switchers({Key? key}) : super(key: key);

  @override
  __SwitchersState createState() => __SwitchersState();
}

class __SwitchersState extends State<_Switchers> {
  late bool _isPost;
  late bool _isStory;
  @override
  void initState() {
    _isPost = true;
    _isStory = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Учитывать посты'),
          leading: SizedBox(
            width: 45,
            child: Switch(
              value: _isPost,
              onChanged: (value) {
                context.read<DetailUserBloc>().switchState(
                      isPost: value,
                      isStory: _isStory,
                    );
                setState(() => _isPost = value);
              },
            ),
          ),
        ),
        ListTile(
          title: const Text('Учитывать истории'),
          leading: SizedBox(
            width: 45,
            child: Switch(
              value: _isStory,
              onChanged: (value) {
                context.read<DetailUserBloc>().switchState(
                      isPost: _isPost,
                      isStory: value,
                    );
                setState(() => _isStory = value);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpText extends StatelessWidget {
  const _HelpText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '*Двойной клик на точке графика - показ постов в данной точке',
        style: TextStyle(
          fontSize: 11,
          color: Colors.black.withOpacity(0.6),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SafeArea(bottom: false, child: SizedBox()),
          const Padding(padding: EdgeInsets.only(top: 20)),
          const _Switchers(),
          CalendarButton(context.watch<DetailUserBloc>().dateRange),
          const Spacer(),
          TextButton(
            onPressed: () => _deleteDialog(context, () {
              context.read<DetailUserBloc>().delUser();
            }),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          const SafeArea(top: false, child: SizedBox()),
        ],
      ),
    );
  }

  Future<void> _deleteDialog(BuildContext context, Function() onDel) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить пользователя?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('ОК'),
              onPressed: () {
                onDel();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
