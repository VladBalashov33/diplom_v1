import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';

class CachedImage extends StatefulWidget {
  const CachedImage(
    this.url, {
    Key? key,
    this.height,
    this.width,
    this.boxFit,
    this.borderRadius = 15,
  }) : super(key: key);

  final String? url;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final double borderRadius;

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  final WebImageDownloader _webImageDownloader = WebImageDownloader();

  Future<void> _downloadImage() async {
    if (widget.url != null) {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(widget.url!)).load("");
      final Uint8List bytes = imageData.buffer.asUint8List();
      print('==$bytes==');
// display it with the Image.memory widget
// Image.memory(bytes);
    }
  }

  @override
  void initState() {
    super.initState();
    // _downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = widget.url != null && (widget.url?.contains('http') ?? false);
    // print(url);
    // print(isUrl);
    // ui.platformViewRegistry.registerViewFactory(
    //   url ?? '',
    //   (int _) => ImageElement()..src = url,
    // );
    return GestureDetector(
      onTap: () {
        _downloadImage();
      },
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        clipBehavior: Clip.antiAlias,
        child: isUrl
            ? !kIsWeb
                ? CachedNetworkImage(
                    imageUrl: widget.url ?? '',
                    height: widget.height,
                    width: widget.width,
                    fit: widget.boxFit ?? BoxFit.cover,
                    progressIndicatorBuilder: (_, __, ___) {
                      return LoadingWidgets.loadingCenter();
                    },
                    errorWidget: (_, __, ___) {
                      return const ErrorContainer();
                    },
                  )
                : SizedBox(
                    height: widget.height,
                    width: widget.width,
                    child: Image.network(
                      widget.url ?? '',
                      height: widget.height,
                      width: widget.width,
                      fit: widget.boxFit ?? BoxFit.cover,
                      loadingBuilder: (_, __, ___) {
                        return LoadingWidgets.loadingCenter();
                      },
                      errorBuilder: (_, __, ___) {
                        return const ErrorContainer();
                      },
                    ),
                  )
            // SizedBox(
            //     height: height,
            //     width: width,
            //     child: HtmlElementView(
            //       viewType: url ?? '',
            //     ),
            //   )
            : Container(
                height: widget.height,
                width: widget.width,
                color: AppColors.grey757575,
              ),
      ),
    );
  }
}

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey757575,
    );
  }
}
