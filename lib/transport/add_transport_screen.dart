import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/transport_model.dart';
import '../data/repository/transport_repository.dart';

class AddTransportScreen extends StatefulWidget {
  const AddTransportScreen({super.key});

  @override
  State<AddTransportScreen> createState() => _AddTransportScreenState();
}

class _AddTransportScreenState extends State<AddTransportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _cityController = TextEditingController();
  final _capacityController = TextEditingController();
  final _volumeController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();

  String? _selectedBodyType;
  DateTime? _availableFrom;
  bool _hasTemperatureControl = false;

  final List<String> _bodyTypes = const [
    'Тент',
    'Рефрижератор',
    'Изотерм',
    'Площадка',
    'Цельнометалл',
    'Контейнер',
    'Цистерна',
    'Негабарит',
  ];

  @override
  void dispose() {
    _cityController.dispose();
    _capacityController.dispose();
    _volumeController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (date != null) {
      setState(() => _availableFrom = date);
    }
  }

  void _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    if (_availableFrom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите дату когда машина свободна')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final transport = TransportModel(
        id: id,
        city: _cityController.text.trim(),
        bodyType: _selectedBodyType!,
        capacity: double.parse(_capacityController.text),
        volume: double.parse(_volumeController.text),
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        ownerRating: 0,
        ownerDeals: 0,
        isVerified: false,
        hasTemperatureControl: _hasTemperatureControl,
        availableFrom: _availableFrom!,
        createdAt: DateTime.now(),
      );

      final repository = TransportRepository();
      await repository.saveTransport(transport);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Машина успешно добавлена!'),
          backgroundColor: Color(0xFF2ECC71),
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.go('/transport');
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Добавить машину', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cityController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Город базирования',
                  hintText: 'Например: Москва',
                  prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white54),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательно' : null,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedBodyType,
                dropdownColor: const Color(0xFF1E3A5F),
                iconEnabledColor: Colors.white70,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Тип кузова',
                ),
                items: _bodyTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (v) => setState(() => _selectedBodyType = v),
                validator: (v) => v == null ? 'Выберите тип кузова' : null,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _capacityController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Грузоподъёмность',
                        suffixText: 'т',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Обязательно';
                        if (double.tryParse(v) == null) return 'Неверный формат';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _volumeController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Объём',
                        suffixText: 'м³',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Обязательно';
                        if (double.tryParse(v) == null) return 'Неверный формат';
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white54, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _availableFrom == null
                              ? 'Доступна с'
                              : _availableFrom.toString().split(' ')[0],
                          style: TextStyle(
                            color: _availableFrom == null ? Colors.white54 : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SwitchListTile(
                value: _hasTemperatureControl,
                onChanged: (v) => setState(() => _hasTemperatureControl = v),
                title: const Text('Температурный режим', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Рефрижератор', style: TextStyle(color: Colors.white70)),
                activeColor: const Color(0xFFFF6B35),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 24),

              const Text('Контакты', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),

              const SizedBox(height: 12),

              TextFormField(
                controller: _ownerNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Имя / Название компании',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательно' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _ownerPhoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательно' : null,
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Добавить машину'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}