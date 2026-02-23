import 'package:flutter/material.dart';

import '../../domain/vehicle.dart';

class VehicleFormResult {
  const VehicleFormResult({
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.initialMileage,
    this.nickname,
    this.serviceIntervalKm,
    this.lastServiceMileage,
    this.lastServiceDate,
    this.licenseExpiryDate,
  });

  final String make;
  final String model;
  final int year;
  final String registrationNumber;
  final DateTime purchaseDate;
  final double purchasePrice;
  final int initialMileage;
  final String? nickname;
  final int? serviceIntervalKm;
  final int? lastServiceMileage;
  final DateTime? lastServiceDate;
  final DateTime? licenseExpiryDate;
}

class VehicleFormPage extends StatefulWidget {
  const VehicleFormPage({super.key, this.initialVehicle});

  final Vehicle? initialVehicle;

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nicknameController;
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _regController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _initialMileageController;
  late final TextEditingController _serviceIntervalController;
  late final TextEditingController _lastServiceMileageController;
  late DateTime _purchaseDate;
  DateTime? _lastServiceDate;
  DateTime? _licenseExpiryDate;

  bool get _isEdit => widget.initialVehicle != null;

  @override
  void initState() {
    super.initState();
    final vehicle = widget.initialVehicle;

    _nicknameController = TextEditingController(text: vehicle?.nickname ?? '');
    _makeController = TextEditingController(text: vehicle?.make ?? '');
    _modelController = TextEditingController(text: vehicle?.model ?? '');
    _yearController = TextEditingController(
      text: vehicle?.year.toString() ?? '',
    );
    _regController = TextEditingController(
      text: vehicle?.registrationNumber ?? '',
    );
    _purchasePriceController = TextEditingController(
      text: vehicle != null ? vehicle.purchasePrice.toStringAsFixed(2) : '',
    );
    _initialMileageController = TextEditingController(
      text: vehicle?.initialMileage.toString() ?? '',
    );
    _serviceIntervalController = TextEditingController(
      text: vehicle?.serviceIntervalKm?.toString() ?? '',
    );
    _lastServiceMileageController = TextEditingController(
      text: vehicle?.lastServiceMileage?.toString() ?? '',
    );
    _purchaseDate = vehicle?.purchaseDate ?? DateTime.now();
    _lastServiceDate = vehicle?.lastServiceDate;
    _licenseExpiryDate = vehicle?.licenseExpiryDate;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _regController.dispose();
    _purchasePriceController.dispose();
    _initialMileageController.dispose();
    _serviceIntervalController.dispose();
    _lastServiceMileageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() => _purchaseDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final year = int.parse(_yearController.text.trim());
    final purchasePrice = double.parse(_purchasePriceController.text.trim());
    final initialMileage = int.parse(_initialMileageController.text.trim());
    final serviceIntervalText = _serviceIntervalController.text.trim();
    final lastServiceMileageText = _lastServiceMileageController.text.trim();

    Navigator.of(context).pop(
      VehicleFormResult(
        nickname: _nicknameController.text.trim().isEmpty
            ? null
            : _nicknameController.text.trim(),
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        year: year,
        registrationNumber: _regController.text.trim(),
        purchaseDate: _purchaseDate,
        purchasePrice: purchasePrice,
        initialMileage: initialMileage,
        serviceIntervalKm: serviceIntervalText.isEmpty
            ? null
            : int.parse(serviceIntervalText),
        lastServiceMileage: lastServiceMileageText.isEmpty
            ? null
            : int.parse(lastServiceMileageText),
        lastServiceDate: _lastServiceDate,
        licenseExpiryDate: _licenseExpiryDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEdit ? 'Edit Vehicle' : 'Add Vehicle';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nicknameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nickname (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _makeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Make'),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _modelController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Model'),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Year'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Year is required';
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null ||
                        parsed < 1900 ||
                        parsed > DateTime.now().year + 1) {
                      return 'Enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _regController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Registration number',
                  ),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Purchase date',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(_purchaseDate),
                        ),
                        const Icon(Icons.calendar_today_outlined),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _purchasePriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Purchase price',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Purchase price is required';
                    }
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _initialMileageController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Initial mileage',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Initial mileage is required';
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid mileage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _serviceIntervalController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Service interval (km, optional)',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid interval';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastServiceMileageController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Last service mileage (optional)',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid mileage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _lastServiceDate ?? now,
                      firstDate: DateTime(now.year - 30),
                      lastDate: DateTime(now.year + 5),
                    );
                    if (picked == null) {
                      return;
                    }
                    setState(() => _lastServiceDate = picked);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Last service date (optional)',
                      suffixIcon: _lastServiceDate == null
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() => _lastServiceDate = null);
                              },
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _lastServiceDate == null
                              ? 'Not set'
                              : MaterialLocalizations.of(
                                  context,
                                ).formatMediumDate(_lastServiceDate!),
                        ),
                        const Icon(Icons.calendar_today_outlined),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _licenseExpiryDate ?? now,
                      firstDate: DateTime(now.year - 5),
                      lastDate: DateTime(now.year + 10),
                    );
                    if (picked == null) {
                      return;
                    }
                    setState(() => _licenseExpiryDate = picked);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'License expiry date (optional)',
                      suffixIcon: _licenseExpiryDate == null
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() => _licenseExpiryDate = null);
                              },
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _licenseExpiryDate == null
                              ? 'Not set'
                              : MaterialLocalizations.of(
                                  context,
                                ).formatMediumDate(_licenseExpiryDate!),
                        ),
                        const Icon(Icons.calendar_today_outlined),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(_isEdit ? 'Update Vehicle' : 'Save Vehicle'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
