import 'package:flutter/material.dart';
import '../../domain/entities/client.dart';
import '../../../core/utils/date_utils.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback onTap;
  
  const ClientCard({
    Key? key,
    required this.client,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      client.clientName.isNotEmpty
                          ? client.clientName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.clientName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (client.companyName != null)
                          Text(
                            client.companyName!,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPotentialColor(client.customerPotential),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          client.customerPotential,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateUtils.getRelativeTime(client.updatedAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16),
                  const SizedBox(width: 4),
                  Text(client.phoneNumber),
                  const Spacer(),
                  const Icon(Icons.business, size: 16),
                  const SizedBox(width: 4),
                  Text(client.businessType),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getPotentialColor(String potential) {
    switch (potential) {
      case 'High':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Low':
      default:
        return Colors.grey;
    }
  }
}