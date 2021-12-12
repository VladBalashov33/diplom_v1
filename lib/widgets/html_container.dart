import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomHtml extends StatelessWidget {
  const CustomHtml(this.url, {Key? key}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.contains('от')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(url),
      );
    }
    return Column(
      children: [
        Html(data: page(url)),
        const Padding(padding: EdgeInsets.only(top: 4)),
        Linkify(
          onOpen: _onOpen,
          text: url,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ],
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  String page(String url) => '''<iframe class="instagram-media
instagram-media-rendered"
id="instagram-embed-0"
src="$url" 
allowtransparency="true" 
allowfullscreen="true" 
frameborder="0" 
height="345" 
data-instgrm-payload-id="instagram-media-payload-0" 
scrolling="no" 
style="background: white; 
max-width: 304px; 
width: calc(100% - 2px); 
border-radius: 3px; 
border: 1px solid rgb(219, 219, 219); 
box-shadow: none; display: block; 
margin: 0px 0px 12px; 
min-width: 326px; 
padding: 0px;">
</iframe>''';
}
