import 'package:flutter/material.dart';

class ClientAvatar extends StatelessWidget {
  final String clientName;
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  
  const ClientAvatar({
    Key? key,
    required this.clientName,
    this.imageUrl,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          
          // shape: BoxShape.circle,
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey.shade600,
                        size: size * 0.5,
                      ),
                    );
                  },
                )
              : Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: backgroundColor ?? Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    clientName.isNotEmpty
                        ? clientName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size * 0.4,
                    ),
                  ),
                ),
        ),
      ),
    ),
    );
  }
}