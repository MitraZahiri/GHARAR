import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// GHARAR Tasarım Sistemine uygun birincil eylem butonu.
///
/// Bağımsız [StatelessWidget] sınıfı olarak inşa edilmiştir.
/// Varsayılan olarak [AppColors.terracotta] rengini ve [AppTextStyles] tipografisini kullanır.
class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 52,
    this.width,
    this.borderRadius = 16,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.terracotta;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: text,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color:
              _isEnabled
                  ? effectiveBackgroundColor
                  : (isDark
                      ? AppColors.earthSlateDeep
                      : AppColors.parchmentBorder),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow:
              _isEnabled
                  ? [
                    BoxShadow(
                      color: effectiveBackgroundColor.withValues(alpha: 0.24),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: _isEnabled ? onPressed : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child:
                    isLoading
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (icon != null) ...[
                                icon!,
                                const SizedBox(width: 8),
                              ],
                              Text(
                                text,
                                style: AppTextStyles.headline(
                                  isDark: false,
                                ).copyWith(
                                  color: textColor ?? Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
