import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/client_provider.dart';
import '../../providers/interaction_provider.dart';
import '../../../domain/entities/client.dart';
import '../../../domain/entities/interaction.dart';
import '../../../core/utils/date_utils.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/interaction_item.dart';
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
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadClient();
    _loadInteractions();
  }
  
  Future<void> _loadClient() async {
    setState(() {
      _isLoading = true;
    });
    
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    final client = await clientProvider.getClientById(widget.clientId);
    
    if (client != null) {
      setState(() {
        _client = client;
        _isLoading = false;
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
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: true,
                  pinned: true,
                  // flexibleSpace: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      _client?.clientName ?? 'Client Details',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 16),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildClientInfo(),
                        const SizedBox(height: 24),
                        _buildActionButtons(),
                        const SizedBox(height: 24),
                        _buildInteractionSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddInteractionScreen(clientId: widget.clientId),
            ),
          ).then((_) => _loadInteractions());
        },
        // backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildClientInfo() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    _client!.clientName.isNotEmpty
                        ? _client!.clientName[0].toUpperCase()
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
                        _client!.clientName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_client!.companyName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _client!.companyName!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.phone, _client!.phoneNumber, 'Phone', () => _makePhoneCall(_client!.phoneNumber)),
            _buildInfoRow(Icons.message, _client!.phoneNumber, 'SMS', () => _sendSMS(_client!.phoneNumber)),
            if (_client!.address != null)
              _buildInfoRow(Icons.location_on, _client!.address!, 'Address', null),
            _buildInfoRow(Icons.business, _client!.businessType, 'Business Type', null),
            _buildInfoRow(
              Icons.computer,
              _client!.usingSystem ? 'Using System' : 'Not Using System',
              'System Status',
              null,
            ),
            _buildInfoRow(
              Icons.trending_up,
              _client!.customerPotential,
              'Customer Potential',
              null,
              color: _getPotentialColor(_client!.customerPotential),
            ),
            _buildInfoRow(
              Icons.access_time,
              AppDateUtils.formatDate(_client!.createdAt),
              'Created Date',
              null,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String text, String label, VoidCallback? onTap, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.grey.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
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
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Edit ',
            icon: Icons.edit,
            isOutlined: true,
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
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(

            text: 'Delete',
            icon: Icons.delete,
            isOutlined: true,
            color: Colors.red,
            onPressed: () {
              if (_client != null) {
                _showDeleteConfirmation();
              }
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildInteractionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddInteractionScreen(clientId: widget.clientId),
                  ),
                ).then((_) => _loadInteractions());
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Interaction'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<InteractionProvider>(
          builder: (context, interactionProvider, child) {
            if (interactionProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (interactionProvider.errorMessage != null) {
              return MessageWidget(
                message: interactionProvider.errorMessage!,
                type: MessageType.error,
              );
            }
            
            if (interactionProvider.interactions.isEmpty) {
              return AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No interactions yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Add First Interaction',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddInteractionScreen(clientId: widget.clientId),
                            ),
                          ).then((_) => _loadInteractions());
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: interactionProvider.interactions.length,
              itemBuilder: (context, index) {
                final interaction = interactionProvider.interactions[index];
                return InteractionItem(
                  interaction: interaction,
                  onTap: () {
                    // Show interaction details in a modal or navigate to detail page
                  },
                  onEdit: () {
                    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddInteractionScreen(
          clientId: widget.clientId,
          interaction: interaction, 
        ),
      ),
    );
                  },
                  // onDelete: () {
                  //   _showDeleteInteractionConfirmation(interaction);
                  // },
                  onDelete: () => _confirmDelete(widget.clientId, interaction.id),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _confirmDelete(String clientId,String interactionId) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Interaction'),
      content: const Text('Are you sure you want to delete this interaction?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    context.read<InteractionProvider>().deleteInteraction(clientId, interactionId);
  }
}

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: Text('Are you sure you want to delete ${_client!.clientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final clientProvider = Provider.of<ClientProvider>(context, listen: false);
              clientProvider.deleteClient(_client!.id).then((_) {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteInteractionConfirmation(Interaction interaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Interaction'),
        content: Text('Are you sure you want to delete this ${interaction.interactionType.toLowerCase()} interaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
             Navigator.of(context).pop();
              final interactionProvider = Provider.of<InteractionProvider>(context, listen: false);
              interactionProvider.deleteInteraction(widget.clientId, interaction.id).then((_) {
                _loadInteractions();
              });
            },
            child: const Text('Delete'),
          ),
        ],
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