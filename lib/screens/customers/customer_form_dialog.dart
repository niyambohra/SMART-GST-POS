import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../utils/validators.dart';

class CustomerFormDialog extends StatefulWidget {
  final Customer? customer;

  const CustomerFormDialog({super.key, this.customer});

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _gstinController;
  late TextEditingController _creditLimitController;

  late CustomerType _selectedType;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameController = TextEditingController(text: c?.name ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _cityController = TextEditingController(text: c?.city ?? 'Mumbai');
    _stateController = TextEditingController(text: c?.state ?? 'Maharashtra');
    _pincodeController = TextEditingController(text: c?.pincode ?? '');
    _gstinController = TextEditingController(text: c?.gstin ?? '');
    _creditLimitController = TextEditingController(
        text: c != null ? c.creditLimit.toStringAsFixed(0) : '10000');
    _selectedType = c?.customerType ?? CustomerType.retail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _gstinController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  void _saveCustomer() {
    if (!_formKey.currentState!.validate()) return;

    final customer = Customer(
      id: widget.customer?.id ?? '',
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      gstin: _gstinController.text.trim().toUpperCase(),
      customerType: _selectedType,
      creditLimit: double.tryParse(_creditLimitController.text.trim()) ?? 10000.0,
      outstandingBalance: widget.customer?.outstandingBalance ?? 0.0,
    );

    Navigator.pop(context, customer);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Customer' : 'Add New Customer'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Customer / Business Name *'),
                  validator: (val) => AppValidators.validateRequired(val, 'Customer name'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number *'),
                        keyboardType: TextInputType.phone,
                        validator: (val) => AppValidators.validatePhone(val, required: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email Address'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<CustomerType>(
                        initialValue: _selectedType,
                        decoration: const InputDecoration(labelText: 'Customer Type'),
                        items: const [
                          DropdownMenuItem(value: CustomerType.retail, child: Text('Retail Consumer')),
                          DropdownMenuItem(value: CustomerType.wholesale, child: Text('Wholesale Buyer (B2B)')),
                          DropdownMenuItem(value: CustomerType.corporate, child: Text('Corporate Account')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedType = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _gstinController,
                        decoration: const InputDecoration(
                          labelText: 'GSTIN (For B2B)',
                          hintText: 'e.g. 27AABCF1234F1Z5',
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: AppValidators.validateGstin,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Street Address'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(labelText: 'State'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _pincodeController,
                        decoration: const InputDecoration(labelText: 'Pincode'),
                        keyboardType: TextInputType.number,
                        validator: AppValidators.validatePincode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _creditLimitController,
                  decoration: const InputDecoration(
                    labelText: 'Credit Limit (₹)',
                    hintText: '10000',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => AppValidators.validatePositiveNumber(v, 'Credit limit', allowZero: true),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveCustomer,
          child: Text(isEditing ? 'Update Customer' : 'Save Customer'),
        ),
      ],
    );
  }
}
