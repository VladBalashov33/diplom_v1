import 'package:diplom/bloc/choose_user_bloc/choose_user_bloc.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/calendar.dart';
import 'package:diplom/widgets/charts/chart_weekday_post.dart';
import 'package:diplom/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SafeArea(bottom: false, child: SizedBox()),
            const Padding(padding: EdgeInsets.only(top: 20)),
            CustomExpansionTile(
              text: 'Сортировка',
              isExpand: true,
              children: [
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
            const CustomExpansionTile(text: 'Фильтр', children: [
              _RangeSliderSubs(),
            ]),
          ],
        ),
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

class _RangeSliderSubs extends StatefulWidget {
  const _RangeSliderSubs({
    Key? key,
  }) : super(key: key);

  @override
  State<_RangeSliderSubs> createState() => _RangeSliderSubsState();
}

class _RangeSliderSubsState extends State<_RangeSliderSubs> {
  late RangeValues rangeValues;
  @override
  void initState() {
    super.initState();
    rangeValues = context.read<ChooseUserBloc>().getSubsRange;
  }

  @override
  Widget build(BuildContext context) {
    final max = context.read<ChooseUserBloc>().subsRangeInit.end.to100();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Кол-во подписчиков',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const Padding(padding: EdgeInsets.only(top: 12)),
        Row(
          children: [
            Text('${rangeValues.start.toInt()}'),
            const Spacer(),
            Text('${rangeValues.end.toInt()}'),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        RangeSlider(
          values: rangeValues,
          onChanged: (value) {
            value = value.to100();
            if (max < value.end) {
              value = RangeValues(value.start, max);
            }
            if (value.start > value.end) {
              value = RangeValues(value.end - 100, value.end);
            }
            context.read<ChooseUserBloc>().setSubsRange(value);
            setState(() => rangeValues = value);
          },
          min: 0,
          max: max,
          divisions: 1000,
        ),
      ],
    );
  }
}
