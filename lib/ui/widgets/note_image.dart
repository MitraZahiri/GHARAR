import 'dart:io';

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Shows a love note's drawing or photo from local storage, with a soft
/// placeholder when the file is missing (e.g. after reinstalling the app).
class NoteImage extends StatelessWidget {
  final String path;
  final bool isPhoto;
  final double aspectRatio;
  final String semanticLabel;

  const NoteImage({
    super.key,
    required this.path,
    required this.isPhoto,
    required this.semanticLabel,
    this.aspectRatio = 4 / 3,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.file(
          File(path),
          fit: isPhoto ? BoxFit.cover : BoxFit.contain,
          semanticLabel: semanticLabel,
          gaplessPlayback: true,
          errorBuilder:
              (_, __, ___) => ColoredBox(
                color: AppColors.terracottaSubtle,
                child: Center(
                  child: Icon(
                    isPhoto ? Icons.image_rounded : Icons.gesture_rounded,
                    size: 32,
                    color: AppColors.terracotta,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
