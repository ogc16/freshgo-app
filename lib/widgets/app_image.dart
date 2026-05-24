import 'package:flutter/material.dart';
import 'ui.dart' show green;

class AppImage extends StatelessWidget {
  final String? assetPath;
  final String? networkUrl;
  final String emoji;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImage({
    super.key,
    this.assetPath,
    this.networkUrl,
    this.emoji = '',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _buildFallback(),
      );
    }
    if (networkUrl != null && networkUrl!.isNotEmpty) {
      return Image.network(
        networkUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _buildFallback(),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Center(child: CircularProgressIndicator(strokeWidth: 2, color: green));
        },
      );
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    if (emoji.isEmpty) return const SizedBox.shrink();
    final size = (width is double && width!.isFinite) ? width! : (height is double && height!.isFinite) ? height! : 60;
    return Center(child: Text(emoji, style: TextStyle(fontSize: size * 0.5)));
  }
}
