import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diplom/utils/utils.dart';
import 'package:diplom/widgets/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isUrl = url != null && (url?.contains('http') ?? false);
    // print(url);
    // print(isUrl);
    // ui.platformViewRegistry.registerViewFactory(
    //   url ?? '',
    //   (int _) => ImageElement()..src = url,
    // );
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: isUrl
          ? !kIsWeb
              ? CachedNetworkImage(
                  imageUrl: url ?? '',
                  height: height,
                  width: width,
                  fit: boxFit ?? BoxFit.cover,
                  progressIndicatorBuilder: (_, __, ___) {
                    return LoadingWidgets.loadingCenter();
                  },
                  errorWidget: (_, __, ___) {
                    return const ErrorContainer();
                  },
                )
              : Container(
                  height: height,
                  width: width,
                  child: Image.network(
                    url ?? '',
                    height: height,
                    width: width,
                    fit: boxFit ?? BoxFit.cover,
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
              height: height,
              width: width,
              color: AppColors.grey757575,
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
