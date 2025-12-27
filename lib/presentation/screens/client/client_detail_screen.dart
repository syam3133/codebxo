import 'package:field_sales_crm/presentation/widgets/common/loading_widget.dart';
import 'package:field_sales_crm/presentation/widgets/common/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/client_provider.dart';
import '../../providers/interaction_provider.dart';
import '../../../domain/entities/client.dart';
import '../../../domain/entities/interaction.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/message_widget.dart';
import 'edit_client_screen.dart';
import '../interaction/add_interaction_screen.dart';


class ClientDetailScreen extends StatefulWidget {
  final String clientId;
  
  const ClientDetailScreen({
    Key? key,
    required this.clientId,
  }) : super(key: key);

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  Client? _client;
  
  @override
  void initState() {
    super.initState();
    _loadClient();
    _loadInteractions();
  }
  
  Future<void> _loadClient() async {
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    final client = await clientProvider.getClientById(widget.clientId);
    
    if (client != null) {
      setState(() {
        _client = client;
      });
    }
  }
  
  Future<void> _loadInteractions() async {
    final interactionProvider = Provider.of<InteractionProvider>(context, listen: false);
    await interactionProvider.getInteractionList(widget.clientId);
  }
  
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    if (!await launchUrl(launchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $phoneNumber'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _sendSMS(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    
    if (!await launchUrl(launchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not send SMS to $phoneNumber'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_client?.clientName ?? 'Client Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (_client != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditClientScreen(client: _client!),
                  ),
                ).then((_) => _loadClient());
              }
            },
          ),
        ],
      ),
      body: _client == null
          ? const LoadingWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _client!.clientName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_client!.companyName != null)
                            Text(
                              _client!.companyName!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 8),
                              Text(_client!.phoneNumber),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.call),
                                onPressed: () => _makePhoneCall(_client!.phoneNumber),
                              ),
                              IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () => _sendSMS(_client!.phoneNumber),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_client!.address != null)
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(_client!.address!),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.business),
                              const SizedBox(width: 8),
                              Text(_client!.businessType),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.computer),
                              const SizedBox(width: 8),
                              Text(_client!.usingSystem ? 'Using System' : 'Not Using System'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.trending_up),
                              const SizedBox(width: 8),
                              Text('Potential: ${_client!.customerPotential}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time),
                              const SizedBox(width: 8),
                              Text('Created: ${AppDateUtils.formatDate(_client!.createdAt)}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Interactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddInteractionScreen(clientId: widget.clientId),
                            ),
                          ).then((_) => _loadInteractions());
                        },
                        child: const Text('Add Interaction'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<InteractionProvider>(
                    builder: (context, interactionProvider, child) {
                      if (interactionProvider.isLoading) {
                        return const LoadingWidget();
                      }
                      
                      if (interactionProvider.errorMessage != null) {
                        return MessageWidget(
                          message: interactionProvider.errorMessage!,
                          type: MessageType.error,
                        );
                      }
                      
                      if (interactionProvider.interactions.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No interactions yet'),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: interactionProvider.interactions.length,
                        itemBuilder: (context, index) {
                          final interaction = interactionProvider.interactions[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _getInteractionIcon(interaction.interactionType),
                                        color: _getInteractionColor(interaction.interactionType),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        interaction.interactionType,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        AppDateUtils.getRelativeTime(interaction.createdAt),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (interaction.notes != null) ...[
                                    const SizedBox(height: 8),
                                    Text(interaction.notes!),
                                  ],
                                  if (interaction.clientReply != null) ...[
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Client Reply:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(interaction.clientReply!),
                                  ],
                                  if (interaction.followUpDate != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.event),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Follow-up: ${AppDateUtils.formatDate(interaction.followUpDate!)}',
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
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