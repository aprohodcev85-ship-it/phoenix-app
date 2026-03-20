import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/cargo_model.dart';
import '../data/repository/cargo_repository.dart';

class AddCargoScreen extends StatefulWidget {
  const AddCargoScreen({super.key});

  @override
  State<AddCargoScreen> createState() => _AddCargoScreenState();
}

class _AddCargoScreenState extends State<AddCargoScreen> {
  // Controllers
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _weightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _tempMinController = TextEditingController();
  final _tempMaxController = TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Selections
  DateTime? _loadingDate;
  String? _selectedBodyTypeId;
  String _selectedLoadingMethodId = 'rear';
  bool _temperatureControl = false;

  // Dictionaries
  final List<Map<String, String>> _bodyTypes = const [
    {'id': 'tente', 'label': 'Тент'},
    {'id': 'refrigerator', 'label': 'Рефрижератор'},
    {'id': 'isothermal', 'label': 'Изотерм'},
    {'id': 'metal', 'label': 'Цельнометалл'},
    {'id': 'flatbed', 'label': 'Площадка'},
    {'id': 'container20', 'label': 'Контейнер 20 фт'},
    {'id': 'container40', 'label': 'Контейнер 40 фт'},
    {'id': 'tanker', 'label': 'Цистерна'},
    {'id': 'oversized', 'label': 'Негабарит'},
  ];

  final List<Map<String, String>> _loadingMethods = const [
    {'id': 'rear', 'label': 'Задняя'},
    {'id': 'side', 'label': 'Боковая'},
    {'id': 'top', 'label': 'Верхняя'},
    {'id': 'full', 'label': 'Полная растентовка'},
    {'id': 'ramp', 'label': 'С аппарелью'},
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _tempMinController.dispose();
    _tempMaxController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _loadingDate = date);
    }
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }

  InputDecoration _decoration({
    required String label,
    String? hint,
    IconData? icon,
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white54) : null,
      suffixText: suffix,
      suffixStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;

    if (!ok) return;

    if (_loadingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите дату загрузки')),
      );
      return;
    }

    if (_temperatureControl) {
      final tMin = double.tryParse(_tempMinController.text.replaceAll(',', '.'));
      final tMax = double.tryParse(_tempMaxController.text.replaceAll(',', '.'));
      if (tMin == null || tMax == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Температура: укажите Min и Max корректно')),
        );
        return;
      }
      if (tMin > tMax) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Температура: Min не может быть больше Max')),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      // Создаём ID
      final String id = DateTime.now().millisecondsSinceEpoch.toString();

      // Создаём модель груза
      final cargo = CargoModel(
        id: id,
        fromCity: _fromController.text.trim(),
        toCity: _toController.text.trim(),
        price: double.parse(_priceController.text.replaceAll(' ', '')),
        distance: 710, // Пока статика
        weight: double.parse(_weightController.text),
        volume: double.parse(_volumeController.text),
        bodyType: _selectedBodyTypeId ?? '',
        loadingDate: _loadingDate!,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
      );

      // Сохраняем через репозиторий
      final repository = CargoRepository();
      await repository.saveCargo(cargo);

      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Груз успешно создан!'),
          backgroundColor: const Color(0xFF2ECC71),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      context.go('/home');
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при создании: $e'),
          backgroundColor: const Color(0xFFE74C3C),
        ),
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
        title: const Text('Добавить груз', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _section('Маршрут'),
              TextFormField(
                controller: _fromController,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(
                  label: 'Город отправления',
                  hint: 'Например: Москва',
                  icon: Icons.location_on_outlined,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательно' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _toController,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(
                  label: 'Город назначения',
                  hint: 'Например: Санкт-Петербург',
                  icon: Icons.flag_outlined,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Обязательно' : null,
              ),

              const SizedBox(height: 24),
              _section('Характеристики'),

              DropdownButtonFormField<String>(
                value: _selectedBodyTypeId,
                dropdownColor: const Color(0xFF1E3A5F),
                iconEnabledColor: Colors.white70,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(label: 'Тип кузова'),
                items: _bodyTypes
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e['id'],
                        child: Text(e['label']!),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedBodyTypeId = v),
                validator: (v) => (v == null) ? 'Выберите тип кузова' : null,
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _decoration(label: 'Вес', hint: '20', suffix: 'т'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Обязательно';
                        final x = double.tryParse(v.replaceAll(',', '.'));
                        if (x == null) return 'Неверный формат';
                        if (x <= 0) return 'Вес должен быть > 0';
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
                      decoration: _decoration(label: 'Объём', hint: '80', suffix: 'м³'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Обязательно';
                        final x = double.tryParse(v.replaceAll(',', '.'));
                        if (x == null) return 'Неверный формат';
                        if (x <= 0) return 'Объём должен быть > 0';
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedLoadingMethodId,
                dropdownColor: const Color(0xFF1E3A5F),
                iconEnabledColor: Colors.white70,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration(label: 'Способ загрузки'),
                items: _loadingMethods
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e['id'],
                        child: Text(e['label']!),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _selectedLoadingMethodId = v);
                },
              ),

              const SizedBox(height: 8),
              SwitchListTile(
                value: _temperatureControl,
                onChanged: (v) {
                  setState(() {
                    _temperatureControl = v;
                    if (!v) {
                      _tempMinController.clear();
                      _tempMaxController.clear();
                    }
                  });
                },
                title: const Text('Температурный режим', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Если нужен рефрижератор', style: TextStyle(color: Colors.white70)),
                activeColor: const Color(0xFFFF6B35),
                contentPadding: EdgeInsets.zero,
              ),

              if (_temperatureControl) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tempMinController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: _decoration(label: 'Min t°', hint: '2', suffix: '°C'),
                        validator: (v) {
                          if (!_temperatureControl) return null;
                          if (v == null || v.trim().isEmpty) return 'Обязательно';
                          final x = double.tryParse(v.replaceAll(',', '.'));
                          if (x == null) return 'Неверно';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _tempMaxController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: _decoration(label: 'Max t°', hint: '6', suffix: '°C'),
                        validator: (v) {
                          if (!_temperatureControl) return null;
                          if (v == null || v.trim().isEmpty) return 'Обязательно';
                          final x = double.tryParse(v.replaceAll(',', '.'));
                          if (x == null) return 'Неверно';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),
              _section('Дата и цена'),

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
                          _loadingDate == null ? 'Выберите дату загрузки' : _formatDate(_loadingDate!),
                          style: TextStyle(
                            color: _loadingDate == null ? Colors.white54 : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: _decoration(label: 'Цена', hint: '120000', suffix: '₽'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Обязательно';
                  final x = int.tryParse(v.trim());
                  if (x == null) return 'Неверный формат';
                  if (x <= 0) return 'Цена должна быть > 0';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              _section('Описание'),

              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: _decoration(
                  label: 'Комментарий',
                  hint: 'Например: боковая загрузка, нужна растентовка...',
                  icon: Icons.description_outlined,
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white54),
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Отмена', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Добавить груз', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}