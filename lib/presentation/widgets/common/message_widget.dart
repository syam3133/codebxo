import 'package:flutter/material.dart';

enum MessageType {
  error,
  success,
  info,
  warning,
}

class MessageWidget extends StatelessWidget {
  final String message;
  final MessageType type;
  final VoidCallback? onDismiss;
  
  const MessageWidget({
    Key? key,
    required this.message,
    required this.type,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    
    switch (type) {
      case MessageType.error:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.error;
        break;
      case MessageType.success:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.check_circle;
        break;
      case MessageType.warning:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.warning;
        break;
      case MessageType.info:
      default:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        icon = Icons.info;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(
                Icons.close,
                color: textColor,
              ),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}