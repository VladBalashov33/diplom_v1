import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:diplom/bloc/friend_info_bloc/friend_info_bloc.dart';
import 'package:diplom/screens/detail_user/hashtag_info.dart';
import 'package:diplom/screens/detail_user/main_info.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/html_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({
    required this.postLinks,
    this.name,
    this.isHashtag = false,
    Key? key,
  }) : super(key: key);
  final List<String> postLinks;
  final String? name;
  final bool isHashtag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? 'Ссылки на посты'),
      ),
      body: BlocProviderBuilder<FriendInfoBloc, FriendInfoState>(
        create: (context) => FriendInfoBloc(isHashtag: isHashtag, name: name),
        builder: (context, state) {
          if (state is FriendInfoLoading) {
            return LoadingWidgets.loadingCenter();
          }
          return Column(
            children: [
              if (name != null && state is! FriendInfoErr) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: isHashtag
                      ? HashtagInfo(
                          tag: context
                              .watch<FriendInfoBloc>()
                              .hashtag!
                              .copyWith(
                                  link: ApiPath.hashtagLink(name!),
                                  userPostCount: postLinks.length),
                        )
                      : context.watch<FriendInfoBloc>().friend != null
                          ? MainInfo(
                              user: context.watch<FriendInfoBloc>().friend!,
                              isExpand: true,
                            )
                          : const SizedBox(),
                ),
              ] else ...[
                const CustomTitle('Ссылка но объект: '),
                Linkify(
                  onOpen: _onOpen,
                  text: isHashtag
                      ? ApiPath.hashtagLink(name!)
                      : ApiPath.getInfoUser(name!),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ],
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 60),
                  itemBuilder: (context, index) {
                    return CustomHtml(postLinks[index]);
                  },
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(top: 12),
                  ),
                  itemCount: postLinks.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
