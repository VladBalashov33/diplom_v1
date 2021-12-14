import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/widgets/html_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = context.watch<DetailUserBloc>().postLinks;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ссылки на посты'),
      ),
      body: ListView.separated(
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
