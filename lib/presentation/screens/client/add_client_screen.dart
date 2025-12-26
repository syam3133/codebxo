import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/location_service.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/message_widget.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({Key? key}) : super(key: key);

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  
  String _businessType = AppConstants.businessTypes.first;
  bool _usingSystem = false;
  String _customerPotential = AppConstants.customerPotential.first;
  
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _locationCaptured = false;
  
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
  
  Future<void> _saveClient() async {
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
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      
      if (authProvider.user == null) return;
      
      final client = Client(
        id: '', // Will be set by the repository
        userId: authProvider.user!.id,
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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await clientProvider.addClient(client);
      
      if (clientProvider.errorMessage == null) {
        Navigator.of(context).pop();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Client'),
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
                          text: 'Save Client',
                          onPressed: _saveClient,
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