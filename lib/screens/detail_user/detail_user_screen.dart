import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/charts/chart_day_post.dart';
import 'package:diplom/widgets/charts/chart_like_count.dart';
import 'package:diplom/widgets/charts/chart_true_false.dart';
import 'package:diplom/widgets/html_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        child: BlocProviderBuilder<DetailUserBloc, DetailUserState>(
          create: (context) => DetailUserBloc(),
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
                actions: <Widget>[Container()],
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

    return ListView(
      padding: Constants.listPadding,
      children: [
        const UserTitle(),
        const MainInfo(),
        CustomExpansionTile(
          text: 'Постов в день',
          children: <Widget>[ChartDayPost(data: user.postInfo.postPerDay())],
        ),
        CustomExpansionTile(
          text: 'Постов в течении дня',
          children: <Widget>[
            ChartAmongDayPost(data: user.postInfo.postAmongDay())
          ],
        ),
        CustomExpansionTile(
          text: 'Количество коммерческих постов',
          children: <Widget>[
            ChartTrueFalse(data: user.postInfo.isCommercialData)
          ],
        ),
        CustomExpansionTile(
          text: 'Количество лайков в постах',
          children: <Widget>[
            ChartLikeCount(
              data: user.postInfo.likeCountByPostData,
              title: 'лайки',
            )
          ],
        ),
        CustomExpansionTile(
          text: 'Количество комментариев в постах',
          children: <Widget>[
            ChartLikeCount(
              data: user.postInfo.commentCountByPostData,
              title: 'комментарии',
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 200)),
        const SafeArea(top: false, child: SizedBox()),
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
    final items = context.watch<DetailUserBloc>().postLinks;
    return Drawer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 60),
        itemBuilder: (context, index) => CustomHtml(items[index]),
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(top: 8),
        ),
        itemCount: items.length,
      ),
    );
  }
}
// class _Drawer extends StatelessWidget {
//   const _Drawer({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           const SafeArea(bottom: false, child: SizedBox()),
//           ...context
//               .watch<DetailUserBloc>()
//               .postLinks
//               .map(
//                 (e) => Linkify(onOpen: _onOpen, text: e),
//               )
//               .toList(),
//           const SafeArea(top: false, child: SizedBox()),
//         ],
//       ),
//     );
//   }

//   Future<void> _onOpen(LinkableElement link) async {
//     if (await canLaunch(link.url)) {
//       await launch(link.url);
//     } else {
//       throw 'Could not launch $link';
//     }
//   }
// }

