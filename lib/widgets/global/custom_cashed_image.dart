import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_shimmer.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomCashedImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final Widget? placeholderWidget;

  const CustomCashedImage(
    this.image, {
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.errorWidget,
    this.placeholderWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String? baseUrl = dotenv.env['API_URL'];
    final String resolvedUrl = image.startsWith('http')
        ? image
        : '${(baseUrl ?? '').replaceAll(RegExp(r'/api/v\d+.*$'), '')}$image';
    return CachedNetworkImage(
      key: UniqueKey(),
      imageUrl: resolvedUrl,
      fadeInDuration: Duration.zero,
      cacheManager: CustomCacheManager(),
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          fit: fit,
          width: width,
          height: height,
        );
      },
      errorWidget: (context, _, _) {
        if (errorWidget != null) return errorWidget!;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: context.textColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(SolarIconsOutline.user, size: 24),
        );
      },
      placeholder: (context, url) {
        if (placeholderWidget != null) return placeholderWidget!;
        return CustomShimmer(
          borderRadius: height?.r,
          child: Container(
            width: width?.r,
            height: height?.r,
            decoration: BoxDecoration(
              color: context.textColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        );
      },
      errorListener: (exception) {},
    );
  }
}

class CustomCacheManager extends CacheManager {
  static const key = "customCache";

  CustomCacheManager()
    : super(Config(key, stalePeriod: const Duration(days: 7)));

  @override
  Future<FileInfo?> getFileFromCache(
    String key, {
    bool ignoreMemCache = false,
  }) async {
    final fileInfo = await super.getFileFromCache(
      key,
      ignoreMemCache: ignoreMemCache,
    );
    if (fileInfo == null || fileInfo.validTill.isBefore(DateTime.now())) {
      return null;
    }
    return fileInfo;
  }
}
