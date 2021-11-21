import 'package:diplom/bloc/choose_user_bloc/choose_user_bloc.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/charts/chart_weekday_post.dart';
import 'package:diplom/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ChooseUserScreen extends StatelessWidget {
  const ChooseUserScreen({Key? key}) : super(key: key);

  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const _Drawer(),
      appBar: AppBar(
        title: const Text('Выберете пользователя'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Open shopping cart',
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: BlocBuilder<ChooseUserBloc, ChooseUserState>(
        builder: (context, state) {
          print('==$state==');
          final users = context.watch<ChooseUserBloc>().users;
          return Stack(
            children: [
              ListView.separated(
                padding: Constants.listPadding,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserListItem(user: users[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 16,
                    thickness: 1.5,
                  );
                },
              ),
              if (state is ChooseUserLoading) LoadingWidgets.loadingCenter(),
              DefaultButton(
                text: 'ssssss',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(),
                        body: const ChartWeekdayPost(
                          data: Constants.chartDataWeekdayPost,
                        ),
                      ),
                    ),
                  );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => Scaffold(
                  //       appBar: AppBar(),
                  //       body: const ChartHourPost(
                  //         data: Constants.chartDataHourPost,
                  //       ),
                  //     ),
                  //   ),
                  // );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => Scaffold(
                  //       appBar: AppBar(),
                  //       body: const ChartDateCount(
                  //         data: Constants.chartDataDateCount,
                  //       ),
                  //     ),
                  //   ),
                  // );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => Scaffold(
                  //       appBar: AppBar(),
                  //       body: const ChartUserCount(
                  //         data: Constants.chartUserCount,
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Drawer extends StatefulWidget {
  const _Drawer({
    Key? key,
  }) : super(key: key);

  @override
  State<_Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<_Drawer> {
  late SortType _sortType;
  late bool _isRevers;
  @override
  void initState() {
    _sortType = context.read<ChooseUserBloc>().getSortType;
    _isRevers = context.read<ChooseUserBloc>().getIsRevers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SafeArea(bottom: false, child: SizedBox()),
          const Padding(padding: EdgeInsets.only(top: 20)),
          ListTile(
            title: const Text('От большего к меньшему'),
            leading: SizedBox(
              width: 45,
              child: Switch(
                value: _isRevers,
                onChanged: (value) {
                  context.read<ChooseUserBloc>().setIsRevers(value);
                  setState(() => _isRevers = value);
                },
              ),
            ),
          ),
          _radioItem(SortType.username),
          _radioItem(SortType.name),
          _radioItem(SortType.subscribers),
          _radioItem(SortType.lastActivity),
          _radioItem(SortType.postCount),
        ],
      ),
    );
  }

  ListTile _radioItem(SortType value) {
    return ListTile(
      title: Text(Constants.sortTypeName[value] ?? ''),
      leading: Radio<SortType>(
        value: value,
        groupValue: _sortType,
        onChanged: (value) {
          final _value = value ?? SortType.name;
          context.read<ChooseUserBloc>().setSortType(_value);
          setState(() => _sortType = _value);
        },
      ),
    );
  }
}
