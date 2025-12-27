import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/location_service.dart';
import '../../../domain/entities/client.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/message_widget.dart';

class EditClientScreen extends StatefulWidget {
  final Client client;
  
  const EditClientScreen({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _clientNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _addressController;
  
  late String _businessType;
  late bool _usingSystem;
  late String _customerPotential;
  
  late double _latitude;
  late double _longitude;
  bool _locationCaptured = false;
  
  @override
  void initState() {
    super.initState();
    
    _clientNameController = TextEditingController(text: widget.client.clientName);
    _phoneNumberController = TextEditingController(text: widget.client.phoneNumber);
    _companyNameController = TextEditingController(text: widget.client.companyName ?? '');
    _addressController = TextEditingController(text: widget.client.address ?? '');
    
    _businessType = widget.client.businessType;
    _usingSystem = widget.client.usingSystem;
    _customerPotential = widget.client.customerPotential;
    
    _latitude = widget.client.latitude;
    _longitude = widget.client.longitude;
    _locationCaptured = true;
  }
  
  @override
  void dispose() {
    _clientNameController.dispose();
    _phoneNumberController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  Future<void> _captureLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationCaptured = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location captured successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _updateClient() async {
    if (_formKey.currentState!.validate()) {
      if (!_locationCaptured) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please capture location'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      
      final updatedClient = Client(
        id: widget.client.id,
        userId: widget.client.userId,
        clientName: _clientNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        companyName: _companyNameController.text.trim().isEmpty
            ? null
            : _companyNameController.text.trim(),
        businessType: _businessType,
        usingSystem: _usingSystem,
        customerPotential: _customerPotential,
        latitude: _latitude,
        longitude: _longitude,
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        createdAt: widget.client.createdAt,
        updatedAt: DateTime.now(),
      );
      
      await clientProvider.updateClient(updatedClient);
      
      if (clientProvider.errorMessage == null) {
        Navigator.of(context).pop();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client'),
        centerTitle: true,
      ),
      body: Consumer<ClientProvider>(
        builder: (context, clientProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _clientNameController,
                    labelText: 'Client Name *',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Client name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneNumberController,
                    labelText: 'Phone Number *',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _companyNameController,
                    labelText: 'Company Name',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _businessType,
                    decoration: const InputDecoration(
                      labelText: 'Type of Business *',
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.businessTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _businessType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Currently Using System:'),
                      const Spacer(),
                      Switch(
                        value: _usingSystem,
                        onChanged: (value) {
                          setState(() {
                            _usingSystem = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _customerPotential,
                    decoration: const InputDecoration(
                      labelText: 'Customer Potential',
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.customerPotential.map((potential) {
                      return DropdownMenuItem(
                        value: potential,
                        child: Text(potential),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _customerPotential = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _locationCaptured
                              ? 'Location: ${_latitude.toStringAsFixed(6)}, ${_longitude.toStringAsFixed(6)}'
                              : 'Location not captured',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: _captureLocation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _addressController,
                    labelText: 'Address',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  clientProvider.isLoading
                      ? const LoadingWidget()
                      : CustomButton(
                          text: 'Update Client',
                          onPressed: _updateClient,
                        ),
                  if (clientProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: MessageWidget(
                        message: clientProvider.errorMessage!,
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