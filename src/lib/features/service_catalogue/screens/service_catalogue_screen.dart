
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/service_model.dart';
import '../providers/catalogue_provider.dart';
import '../widgets/service_category_section.dart';

class ServiceCatalogueScreen extends StatelessWidget {
  const ServiceCatalogueScreen({super.key});

  static const Color primaryColor = Color(0xFF58372B);
  static const Color backgroundColor = Color(0xFFF7F2E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Service Catalogue',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<CatalogueProvider>(
        builder: (context, provider, child) {
          final services = provider.filteredServices;

          return Column(
            children: [
              _buildHeader(),
              _buildCategoryFilters(provider),
              Expanded(
                child: services.isEmpty
                    ? const Center(
                        child: Text('No services available.'),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          20, 0, 20, 24,
                        ),
                        children: _buildServiceSections(
                          context,
                          services,
                          provider,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _showServiceDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Manage your services and pricing.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF89766D),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(CatalogueProvider provider) {
    const categories = {
      'all': 'All',
      'gel': 'Gel Manicure',
      'extensions': 'Extensions',
      'care': 'Care',
    };

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: categories.entries.map((entry) {
          final isSelected =
              provider.selectedCategory == entry.key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              selectedColor: primaryColor,
              backgroundColor: const Color(0xFFE9DFD2),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : primaryColor,
                fontWeight: FontWeight.w500,
              ),
              onSelected: (_) {
                provider.selectCategory(entry.key);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildServiceSections(
    BuildContext context,
    List<ServiceModel> services,
    CatalogueProvider provider,
  ) {
    final groups = <String, List<ServiceModel>>{
      'Classic Gel Manicure': [],
      'Classic Gel Extensions': [],
      'Removal': [],
      'Henna Manicure': [],
      'Add-ons': [],
      'Other Services': [],
    };

    for (final service in services) {
      final name = service.serviceName.toLowerCase();
      final description = service.serviceDescription.toLowerCase();

      if (name.contains('builder gel')) {
        groups['Add-ons']!.add(service);
      } else if (description.contains('classic gel manicure')) {
        groups['Classic Gel Manicure']!.add(service);
      } else if (description.contains('classic gel extensions')) {
        groups['Classic Gel Extensions']!.add(service);
      } else if (name.contains('removal')) {
        groups['Removal']!.add(service);
      } else if (description.contains('henna')) {
        groups['Henna Manicure']!.add(service);
      } else {
        groups['Other Services']!.add(service);
      }
    }

    return groups.entries
        .where((entry) => entry.value.isNotEmpty)
        .map(
          (entry) => ServiceCategorySection(
            title: entry.key,
            services: entry.value,
            onEdit: (service) {
              _showServiceDialog(
                context,
                service: service,
              );
            },
            onDelete: (service) {
              _confirmDelete(context, provider, service);
            },
          ),
        )
        .toList();
  }

  Future<void> _showServiceDialog(
    BuildContext context, {
    ServiceModel? service,
  }) async {
    final result = await showDialog<ServiceModel>(
      context: context,
      builder: (_) => ServiceFormDialog(service: service),
    );

    if (!context.mounted || result == null) return;

    final provider = context.read<CatalogueProvider>();

    if (service != null) {
      provider.updateService(result);
    } else {
      provider.addService(result);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CatalogueProvider provider,
    ServiceModel service,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Service'),
          content: Text(
            'Are you sure you want to delete ${service.serviceName}?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      provider.removeService(service.serviceId);
    }
  }
}

class ServiceFormDialog extends StatefulWidget {
  final ServiceModel? service;

  const ServiceFormDialog({
    super.key,
    this.service,
  });

  @override
  State<ServiceFormDialog> createState() =>
      _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  late String _selectedCategory;

  bool get isEditing => widget.service != null;

  @override
  void initState() {
    super.initState();

    final service = widget.service;

    _nameController = TextEditingController(
      text: service?.serviceName ?? '',
    );

    _descriptionController = TextEditingController(
      text: service?.serviceDescription ?? '',
    );

    _priceController = TextEditingController(
      text: service?.servicePrice.toString() ?? '',
    );

    _selectedCategory = service?.serviceCategory ?? 'gel';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveService() {
    if (!_formKey.currentState!.validate()) return;

    final service = widget.service;

    final newService = ServiceModel(
      serviceId: service?.serviceId ??
          'SRV-${DateTime.now().millisecondsSinceEpoch}',
      serviceName: _nameController.text.trim(),
      serviceDescription: _descriptionController.text.trim(),
      servicePrice: double.parse(_priceController.text.trim()),
      serviceDurationMins: service?.serviceDurationMins ?? 0,
      serviceCategory: _selectedCategory,
    );

    Navigator.of(context).pop(newService);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing ? 'Edit Service' : 'Add New Service',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a service name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price (RM)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final price = double.tryParse(value ?? '');

                  if (price == null || price < 0) {
                    return 'Enter a valid price.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'gel',
                    child: Text('Gel'),
                  ),
                  DropdownMenuItem(
                    value: 'extensions',
                    child: Text('Extensions'),
                  ),
                  DropdownMenuItem(
                    value: 'care',
                    child: Text('Care'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveService,
          child: Text(
            isEditing ? 'Save Changes' : 'Add Service',
          ),
        ),
      ],
    );
  }
}
