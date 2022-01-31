// ignore_for_file: lines_longer_than_80_chars

import 'package:diplom/bloc/choose_user_bloc/choose_user_bloc.dart';
import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/models/chart_item.dart';
import 'package:diplom/models/post.dart';
import 'package:diplom/screens/links_screen.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/calendar.dart';
import 'package:diplom/widgets/charts/chart_day_post.dart';
import 'package:diplom/widgets/charts/chart_like_count.dart';
import 'package:diplom/widgets/charts/chart_true_false.dart';
import 'package:diplom/widgets/charts/chart_user_count.dart';
import 'package:diplom/widgets/custom_table.dart';
import 'package:diplom/widgets/html_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../map.dart';
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
    final _allPosts = context.watch<DetailUserBloc>().allPosts;

    final _dayPost = _posts.postPerPeriod(DateType.day);
    final _monthsPost = _posts.postPerPeriod(DateType.month);

    final _allDayPost = _allPosts.postPerPeriod(DateType.day);
    final _allDaysMean = PostFunc.meanPost(_allDayPost);
    final _allMonthsMean =
        PostFunc.meanPost(_allPosts.postPerPeriod(DateType.month));

    return ListView(
      padding: Constants.listPadding,
      children: [
        UserTitle(user: context.watch<DetailUserBloc>().user),
        MainInfo(user: context.watch<DetailUserBloc>().user),
        const _HelpText(),
        if (_posts.locCount != 0)
          Align(
            alignment: Alignment.centerLeft,
            child: DefaultButton(
              text: '${_posts.locCount} записей на карте',
              width: 360,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MapPage(
                      posts: _allPosts.posts,
                    ),
                  ),
                );
              },
            ),
          ),
        CustomExpansionTile(
          text: 'Постов в месяц',
          children: <Widget>[
            CustomTable(children: [
              TableRow(children: [
                const CustomTitle('ср.з. постов в день за все время: '),
                CustomText('$_allMonthsMean'),
              ]),
              TableRow(children: [
                const CustomTitle('ср.з. постов в день за выбранный период: '),
                CustomText('${PostFunc.meanPost(_monthsPost)}'),
              ]),
            ]),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ChartDayPost(
              data: _monthsPost,
              dateFormat: DateFormat.MMM(),
            )
          ],
        ),
        CustomExpansionTile(
          text: 'Постов в день',
          children: <Widget>[
            CustomTable(children: [
              TableRow(children: [
                const CustomTitle('ср.з. постов в день за все время: '),
                CustomText('$_allDaysMean'),
              ]),
              TableRow(children: [
                const CustomTitle('ср.з. постов в день за выбранный период: '),
                CustomText('${PostFunc.meanPost(_dayPost)}'),
              ]),
            ]),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ChartDayPost(data: _dayPost)
          ],
        ),
        CustomExpansionTile(
          text: 'Постов в течении дня',
          children: <Widget>[
            const CustomTitle('За выбранное время: '),
            ..._dayPeriodMean(_dayPost),
            const CustomTitle('За все время: '),
            ..._dayPeriodMean(_allDayPost),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ChartCurricular(data: PostFunc.postAmongDayPeriod(_posts.posts)),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ChartAmongDayPost(data: _posts.postAmongDay()),
          ],
        ),
        CustomExpansionTile(
          text: 'Количество лайков в постах',
          children: <Widget>[
            CustomTable(children: [
              TableRow(children: [
                const CustomTitle('ср.з. лайков к посту за все время: '),
                CustomText('${_allPosts.meanLikes}'),
              ]),
              TableRow(children: [
                const CustomTitle('ср.з. лайков к посту за выбранный период: '),
                CustomText('${_posts.meanLikes}'),
              ]),
            ]),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ChartLikeCount(
              data: _posts.likeCountByPostData,
              title: 'лайки',
            )
          ],
        ),
        CustomExpansionTile(
          text: 'Количество комментариев в постах',
          children: <Widget>[
            CustomTable(children: [
              TableRow(children: [
                const CustomTitle('ср.з. комментариев к посту за все время: '),
                CustomText('${_allPosts.meanComment}'),
              ]),
              TableRow(children: [
                const CustomTitle(
                    'ср.з. комментариев к посту за выбранный период: '),
                CustomText('${_posts.meanComment}'),
              ]),
            ]),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ChartLikeCount(
              data: _posts.commentCountByPostData,
              title: 'комментарии',
            )
          ],
        ),
        CustomExpansionTile(
          text: hashtag[0],
          children: <Widget>[
            CustomTable(children: [
              TableRow(children: [
                const CustomTitle('ср.з. тэгов к посту за все время: '),
                CustomText('${_allPosts.meanTags}'),
              ]),
              TableRow(children: [
                const CustomTitle('ср.з. тэгов к посту за выбранный период: '),
                CustomText('${_posts.meanTags}'),
              ]),
            ]),
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

  String? dayPStr(PeriodDay per) => dayPeriodStrings[per]?.toLowerCase();

  List<Widget> _dayPeriodMean(List<ChartDataItem> postPerPeriod) {
    final items = PostFunc.dayPeriodMean(postPerPeriod);
    return [
      CustomTable(children: [
        TableRow(children: [
          CustomTitle('Cр.з. постов ${dayPStr(PeriodDay.morning)}: '),
          CustomText('${items[PeriodDay.morning]}'),
        ]),
      ]),
      CustomTable(children: [
        TableRow(children: [
          CustomTitle('Cр.з. постов ${dayPStr(PeriodDay.day)}: '),
          CustomText('${items[PeriodDay.day]}'),
        ]),
      ]),
      CustomTable(children: [
        TableRow(children: [
          CustomTitle('Cр.з. постов ${dayPStr(PeriodDay.evening)}: '),
          CustomText('${items[PeriodDay.evening]}'),
        ]),
      ]),
      CustomTable(children: [
        TableRow(children: [
          CustomTitle('Cр.з. постов ${dayPStr(PeriodDay.night)}: '),
          CustomText('${items[PeriodDay.night]}'),
        ]),
      ]),
    ];
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
