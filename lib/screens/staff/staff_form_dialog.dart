import 'package:flutter/material.dart';
import '../../models/staff_member.dart';
import '../../utils/validators.dart';

class StaffFormDialog extends StatefulWidget {
  final StaffMember? staff;

  const StaffFormDialog({super.key, this.staff});

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late UserRole _selectedRole;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final s = widget.staff;
    _nameController = TextEditingController(text: s?.name ?? '');
    _emailController = TextEditingController(text: s?.email ?? '');
    _phoneController = TextEditingController(text: s?.phone ?? '');
    _selectedRole = s?.role ?? UserRole.cashier;
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveStaff() {
    if (!_formKey.currentState!.validate()) return;

    final member = StaffMember(
      id: widget.staff?.id ?? '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      isActive: _isActive,
      createdAt: widget.staff?.createdAt,
      lastActive: widget.staff?.lastActive,
    );

    Navigator.pop(context, member);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.staff != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Staff Member' : 'Add Staff Member'),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name *'),
                  validator: (v) => AppValidators.validateRequired(v, 'Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address *'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => AppValidators.validateRequired(v, 'Email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: AppValidators.validatePhone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Assign Role & Access Level'),
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.cashier,
                      child: Text('Cashier (POS Register & Search)'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.manager,
                      child: Text('Manager (POS, Inventory & Sales Reports)'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.admin,
                      child: Text('Admin / Owner (Full Unrestricted Access)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active Status'),
                  subtitle: Text(_isActive ? 'Allowed to log in' : 'Access deactivated'),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                  contentPadding: EdgeInsets.zero,
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
          onPressed: _saveStaff,
          child: Text(isEditing ? 'Update Staff' : 'Add Staff'),
        ),
      ],
    );
  }
}
