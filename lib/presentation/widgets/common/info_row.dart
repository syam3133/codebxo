import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? label;
  final VoidCallback? onTap;
  final Color? color;
  final Color? iconColor;
  final double? iconSize;
  final bool isBold;
  
  const InfoRow({
    Key? key,
    required this.icon,
    required this.text,
    this.label,
    this.onTap,
    this.color,
    this.iconColor,
    this.iconSize,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Theme.of(context).primaryColor,
              size: iconSize ?? 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) ...[
                    Text(
                      label!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: color ?? Colors.black87,
                      fontSize: isBold ? 16 : 14,
                      fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}