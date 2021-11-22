import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/charts/chart_day_post.dart';
import 'package:diplom/widgets/charts/chart_true_false.dart';
import 'package:flutter/material.dart';
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
    return Provider<User>.value(
      value: user,
      child: Provider<GlobalKey<ScaffoldState>>.value(
        value: scaffoldKey,
        child: Scaffold(
          key: scaffoldKey,
          endDrawer: const _Drawer(),
          appBar: AppBar(
            title: Text(user.username),
          ),
          body: const _Body(),
          //  BlocProviderBuilder<, >(
          //   create: (context) => (),
          //   builder: (context, state) {
          //     return Stack(
          //       children: [
          //         const _Body(),
          //         if (state is ChooseUserLoading)
          // LoadingWidgets.loadingCenter(),
          //       ],
          //     );
          //   },
          // ),
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

    return ListView(
      padding: Constants.listPadding,
      children: [
        const UserTitle(),
        const MainInfo(),
        CustomExpansionTile(
          text: 'Количество коммерческих постов',
          children: <Widget>[
            ChartTrueFalse(data: user.postInfo.isCommercialData)
          ],
        ),
        CustomExpansionTile(
          text: 'Количество коммерческих постов',
          children: <Widget>[ChartDayPost(data: user.postInfo.postPerDay())],
        ),
      ],
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
          Text('text'),
          Text('text'),
          Text('text'),
        ],
      ),
    );
  }
}
