import 'package:field_sales_crm/core/utils/date_utils.dart';
import 'package:field_sales_crm/domain/entities/interaction.dart';
import 'package:flutter/material.dart' hide DateUtils;

import 'package:provider/provider.dart';
import '../../providers/interaction_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/message_widget.dart';
import '../../../core/utils/date_utils.dart';

class AddInteractionScreen extends StatefulWidget {
  final String clientId;
  
  const AddInteractionScreen({
    Key? key,
    required this.clientId,
  }) : super(key: key);

  @override
  State<AddInteractionScreen> createState() => _AddInteractionScreenState();
}

class _AddInteractionScreenState extends State<AddInteractionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _clientReplyController = TextEditingController();
  
  String _interactionType = AppConstants.interactionTypes.first;
  DateTime? _followUpDate;
  
  @override
  void dispose() {
    _notesController.dispose();
    _clientReplyController.dispose();
    super.dispose();
  }
  
  Future<void> _selectFollowUpDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _followUpDate = picked;
      });
    }
  }
  
  Future<void> _saveInteraction() async {
    if (_formKey.currentState!.validate()) {
      final interactionProvider = Provider.of<InteractionProvider>(context, listen: false);
      
      final interaction = Interaction(
        id: '', 
        clientId: widget.clientId,
        interactionType: _interactionType,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        clientReply: _clientReplyController.text.trim().isEmpty
            ? null
            : _clientReplyController.text.trim(),
        followUpDate: _followUpDate,
        createdAt: DateTime.now(),
      );
      
      await interactionProvider.addInteraction(interaction);
      
      if (interactionProvider.errorMessage == null) {
        Navigator.of(context).pop();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Interaction'),
        centerTitle: true,
      ),
      body: Consumer<InteractionProvider>(
        builder: (context, interactionProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _interactionType,
                    decoration: const InputDecoration(
                      labelText: 'Interaction Type',
                      border: OutlineInputBorder(),
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
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _notesController,
                    labelText: 'Notes',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _clientReplyController,
                    labelText: 'Client Reply',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectFollowUpDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Follow-up Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _followUpDate != null
                            ? AppDateUtils.formatDate(_followUpDate!)
                            : 'Select follow-up date',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  interactionProvider.isLoading
                      ? const LoadingWidget()
                      : CustomButton(
                          text: 'Save Interaction',
                          onPressed: _saveInteraction,
                        ),
                  if (interactionProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: MessageWidget(
                        message: interactionProvider.errorMessage!,
                        type: MessageType.error,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}