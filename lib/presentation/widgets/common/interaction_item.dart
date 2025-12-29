import 'package:field_sales_crm/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/interaction.dart';
import '../../../core/utils/date_utils.dart';

class InteractionItem extends StatelessWidget {
  final Interaction interaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  const InteractionItem({
    Key? key,
    required this.interaction,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getInteractionColor(interaction.interactionType),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getInteractionIcon(interaction.interactionType),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interaction.interactionType,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppDateUtils.getRelativeTime(interaction.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        const SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (interaction.notes != null && interaction.notes!.isNotEmpty) ...[
            const Text(
              'Notes:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                interaction.notes!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (interaction.clientReply != null && interaction.clientReply!.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Client Reply:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          interaction.clientReply!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (interaction.followUpDate != null) ...[
            Row(
              children: [
                Icon(
                  Icons.event,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Follow-up: ${AppDateUtils.formatDate(interaction.followUpDate!)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  IconData _getInteractionIcon(String interactionType) {
    switch (interactionType) {
      case 'Call':
        return Icons.call;
      case 'Message':
        return Icons.message;
      case 'Meeting':
        return Icons.people;
      case 'Email':
        return Icons.email;
      default:
        return Icons.note;
    }
  }
  
  Color _getInteractionColor(String interactionType) {
    switch (interactionType) {
      case 'Call':
        return Colors.green;
      case 'Message':
        return Colors.blue;
      case 'Meeting':
        return Colors.purple;
      case 'Email':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}