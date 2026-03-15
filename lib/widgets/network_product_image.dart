import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkProductImage extends StatelessWidget {
  const NetworkProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final fallbackSeed = imageUrl.hashCode.abs();
    final fallbackUrl = 'https://picsum.photos/seed/$fallbackSeed/800/800';

    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) => Container(
        color: const Color(0xFFF3E7DE),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.network(
        fallbackUrl,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFF3E7DE),
            child: const Center(child: Icon(Icons.image_not_supported_rounded)),
          );
        },
      ),
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
