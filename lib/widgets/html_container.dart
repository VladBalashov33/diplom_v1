import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomHtml extends StatelessWidget {
  const CustomHtml(this.url, {Key? key}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Html(data: page(url));
  }

  String page(String url) => '''<iframe class="instagram-media
instagram-media-rendered"
id="instagram-embed-0"
src="$url" 
allowtransparency="true" 
allowfullscreen="true" 
frameborder="0" 
height="445" 
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
