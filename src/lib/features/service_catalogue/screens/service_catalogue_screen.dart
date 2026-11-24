
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/service_model.dart';
import '../../../widgets/owner_actions.dart';
import '../providers/catalogue_provider.dart';
import '../service_groups.dart';
import '../widgets/service_category_filter.dart';
import '../widgets/service_category_section.dart';

class ServiceCatalogueScreen extends StatelessWidget {
  const ServiceCatalogueScreen({super.key});

  // Brand colours: Night Bordeaux, Cool Horizon, Ivory Mist
  static const Color primaryColor = AppColors.nightBordeaux;
  static const Color backgroundColor = AppColors.ivoryMist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.nightBordeaux,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Service Catalogue'),
        actions: const [OwnerActions()],
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
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(CatalogueProvider provider) {
    return ServiceCategoryFilter(
      selected: provider.selectedCategory,
      onSelected: provider.selectCategory,
    );
  }

  List<Widget> _buildServiceSections(
    BuildContext context,
    List<ServiceModel> services,
    CatalogueProvider provider,
  ) {
    // Same groups as the customer Choose Service screen.
    final groups = ServiceGroups.group(services);

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
                    value: 'addon',
                    child: Text('Add-on'),
                  ),
                  DropdownMenuItem(
                    value: 'removal',
                    child: Text('Removal'),
                  ),
                  DropdownMenuItem(
                    value: 'henna',
                    child: Text('Henna'),
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
