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
  final double? radius;

  const CustomCashedImage(
    this.image, {
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.errorWidget,
    this.placeholderWidget,
    this.radius = 6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String? baseUrl = dotenv.env['API_URL'];
    final String resolvedUrl = image.startsWith('http')
        ? image
        : '${(baseUrl ?? '').replaceAll(RegExp(r'/api/v\d+.*$'), '')}$image';
    return CachedNetworkImage(
      key: ValueKey(resolvedUrl),
      imageUrl: resolvedUrl,
      fadeInDuration: Duration.zero,
      cacheManager: CustomCacheManager(),
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          fit: fit,
          width: width?.h,
          height: height?.h,
        );
      },
      errorWidget: (context, _, _) {
        if (errorWidget != null) return errorWidget!;
        return Container(
          width: width?.h,
          height: height?.h,
          decoration: BoxDecoration(
            color: context.textColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(radius!.r),
          ),
          child: Icon(SolarIconsOutline.album, size: (height?.sp ?? 24.sp) / 2),
        );
      },
      placeholder: (context, url) {
        if (placeholderWidget != null) return placeholderWidget!;
        return CustomShimmer(
          borderRadius: radius?.r,
          child: Container(
            width: width?.h,
            height: height?.h,
            decoration: BoxDecoration(
              color: context.textColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(radius!.r),
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
