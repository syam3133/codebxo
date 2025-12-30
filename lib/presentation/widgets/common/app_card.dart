import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? color;
  final LinearGradient? gradient;
  final double? elevation;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isSelected;
  final double? borderRadius;
  final double? shadowOpacity;

  const AppCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.gradient,
    this.elevation,
    this.onTap,
    this.isLoading = false,
    this.isSelected = false,
    this.borderRadius = 12,
    this.shadowOpacity = 0.15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius!);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? (color ?? Colors.white) : null,
        borderRadius: radius,
        border: isSelected
            ? Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity!),
            blurRadius: elevation ?? 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: radius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
