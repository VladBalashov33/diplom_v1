import 'package:diplom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'main_info.dart';
import 'user_title.dart';

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
        body: const _Body(),
        //  BlocProviderBuilder<, >(
        //   create: (context) => (),
        //   builder: (context, state) {
        //     return Stack(
        //       children: [
        //         const _Body(),
        //         if (state is ChooseUserLoading) LoadingWidgets.loadingCenter(),
        //       ],
        //     );
        //   },
        // ),
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
    return ListView(
      padding: Constants.listPadding,
      children: const [
        UserTitle(),
        MainInfo(),
      ],
    );
  }
}
