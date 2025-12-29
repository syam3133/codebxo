import 'package:field_sales_crm/presentation/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/interaction_provider.dart';
import '../../../domain/entities/interaction.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/message_widget.dart';

class EditInteractionScreen extends StatefulWidget {
  final Interaction interaction;
  final VoidCallback? onSave;
  
  const EditInteractionScreen({
    Key? key,
    required this.interaction,
    this.onSave,
  }) : super(key: key);

  @override
  State<EditInteractionScreen> createState() => _EditInteractionScreenState();
}

class _EditInteractionScreenState extends State<EditInteractionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _clientReplyController = TextEditingController();
  late String _interactionType;
  DateTime? _followUpDate;
  
  @override
  void initState() {
    super.initState();
    _notesController.text = widget.interaction.notes ?? '';
    _clientReplyController.text = widget.interaction.clientReply ?? '';
    _interactionType = widget.interaction.interactionType;
    _followUpDate = widget.interaction.followUpDate;
  }
  
  @override
  void dispose() {
    _notesController.dispose();
    _clientReplyController.dispose();
    super.dispose();
  }
  
  Future<void> _saveInteraction() async {
    if (_formKey.currentState!.validate()) {
      final interactionProvider = Provider.of<InteractionProvider>(context, listen: false);
      
      final updatedInteraction = Interaction(
        id: widget.interaction.id,
        clientId: widget.interaction.clientId,
        interactionType: _interactionType,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        clientReply: _clientReplyController.text.trim().isEmpty ? null : _clientReplyController.text.trim(),
        followUpDate: _followUpDate,
        createdAt: widget.interaction.createdAt,
      );
      
      await interactionProvider.updateInteraction(updatedInteraction);
      
      if (interactionProvider.errorMessage == null) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        // if (onSave != null) {
        //   onSave!();
        // }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Interaction'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interaction Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _interactionType,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      items: AppConstants.interactionTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _interactionType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _notesController,
                      hintText: 'Enter any notes about this interaction...',
                      maxLines: 5, labelText: '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Client Reply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _clientReplyController,
                      hintText: 'Enter the client\'s reply...',
                      maxLines: 3, labelText: '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Follow-up Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        _selectFollowUpDate();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _followUpDate != null
                                    ? 'Select follow-up date'
                                    : 'Follow-up: ${_followUpDate!.day}-${_followUpDate!.month}-${_followUpDate!.year}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              Consumer<InteractionProvider>(
                builder: (context, interactionProvider, child) {
                  return AppButton(
                    text: 'Save Changes',
                    isLoading: interactionProvider.isLoading,
                    onPressed: _saveInteraction,
                  );
                },
              ),
        
              // if (interactionProvider.errorMessage != null)
              //   MessageWidget(
              //     message: interactionProvider.errorMessage!,
              //     type: MessageType.error,
              //   ),
            ],
          ),
        
          ),
        ),
      
    );
  }
  
  Future<void> _selectFollowUpDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _followUpDate = picked;
      });
    }
  }
}