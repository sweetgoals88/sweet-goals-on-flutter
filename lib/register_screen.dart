import 'package:flutter/material.dart';
import 'package:prubea1app/components/custom_elevated_button.dart';
import 'package:prubea1app/components/custom_email_field.dart';
import 'package:prubea1app/components/custom_password_field.dart';
import 'package:prubea1app/components/custom_text_field_controller.dart';
import 'package:prubea1app/api/api_interface.dart';
import 'package:prubea1app/db/location_option.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _activationCodeInvalid = false;
  bool _isSubmitting = false;
  List<LocationOption> _locationOptions = [];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  Timer? _debounce;

  final CustomTextFieldController _nameController = CustomTextFieldController();
  final CustomTextFieldController _surnameController =
      CustomTextFieldController();
  final CustomTextFieldController _emailController =
      CustomTextFieldController();
  final CustomTextFieldController _passwordController =
      CustomTextFieldController();
  final CustomTextFieldController _confirmPasswordController =
      CustomTextFieldController();
  final CustomTextFieldController _activationCodeController =
      CustomTextFieldController();
  final CustomTextFieldController _peakVoltageController =
      CustomTextFieldController();
  final CustomTextFieldController _temperatureRateController =
      CustomTextFieldController();
  final CustomTextFieldController _solarPanelsController =
      CustomTextFieldController();
  final CustomTextFieldController _labelController =
      CustomTextFieldController();
  final CustomTextFieldController _locationController =
      CustomTextFieldController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _animationController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _activationCodeController.dispose();
    _peakVoltageController.dispose();
    _temperatureRateController.dispose();
    _solarPanelsController.dispose();
    _labelController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _validateActivationCode() async {
    setState(() {
      _isLoading = true;
      _activationCodeInvalid = false;
    });

    try {
      await validateActivationCode(_activationCodeController.text.trim());
      _goToNextStep();
    } catch (e) {
      setState(() {
        _activationCodeInvalid = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLocationOptions(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final options = await geocode(query);
        setState(() {
          _locationOptions = options;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar ubicaciones: $e")),
        );
      }
    });
  }

  void _goToNextStep() {
    setState(() {
      _currentStep++;
    });
    _animationController.forward(from: 0);
  }

  void _goToPreviousStep() {
    setState(() {
      _currentStep--;
    });
    _animationController.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  final slideAnimation = Tween<Offset>(
                    begin:
                        _currentStep > 0
                            ? const Offset(-1, 0)
                            : const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(
                    position: slideAnimation,
                    child: child,
                  );
                },
                child: _buildStep(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    if (_currentStep == 0) {
      return StepOne(
        key: const ValueKey(0),
        nameController: _nameController,
        surnameController: _surnameController,
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        onNext: () {
          if (_formKey.currentState!.validate()) {
            _goToNextStep();
          }
        },
      );
    } else if (_currentStep == 1) {
      return StepTwo(
        key: const ValueKey(1),
        activationCodeController: _activationCodeController,
        peakVoltageController: _peakVoltageController,
        temperatureRateController: _temperatureRateController,
        solarPanelsController: _solarPanelsController,
        isLoading: _isLoading,
        activationCodeInvalid: _activationCodeInvalid,
        onPrevious: _goToPreviousStep,
        onNext: () {
          if (_formKey.currentState!.validate()) {
            _validateActivationCode();
          }
        },
      );
    } else if (_currentStep == 2) {
      return StepThree(
        key: const ValueKey(2),
        isSubmitting: _isSubmitting,
        labelController: _labelController,
        locationController: _locationController,
        locationOptions: _locationOptions,
        loadLocationOptions: _loadLocationOptions,
        onPrevious: _goToPreviousStep,
        onFinish: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isSubmitting = true;
            });

            try {
              await signupCustomer(
                name: _nameController.text.trim(),
                surname: _surnameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
                activationCode: _activationCodeController.text.trim(),
                latitude:
                    _locationOptions
                        .firstWhere(
                          (option) =>
                              option.locationName == _locationController.text,
                        )
                        .latitude,
                longitude:
                    _locationOptions
                        .firstWhere(
                          (option) =>
                              option.locationName == _locationController.text,
                        )
                        .longitude,
                label: _labelController.text.trim(),
                numberOfPanels: int.parse(_solarPanelsController.text.trim()),
                peakVoltage: double.parse(_peakVoltageController.text.trim()),
                temperatureRate: double.parse(
                  _temperatureRateController.text.trim(),
                ),
              );

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Usuario registrado correctamente")),
              );
              context.push("/login");
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error al registrar usuario")),
              );
            } finally {
              setState(() {
                _isSubmitting = false;
              });
            }
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class StepOne extends StatelessWidget {
  final CustomTextFieldController nameController;
  final CustomTextFieldController surnameController;
  final CustomTextFieldController emailController;
  final CustomTextFieldController passwordController;
  final CustomTextFieldController confirmPasswordController;
  final VoidCallback onNext;

  const StepOne({
    required this.nameController,
    required this.surnameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Paso 1: Información personal",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(labelText: "Nombre"),
          validator:
              (value) =>
                  value == null || value.isEmpty ? "Campo requerido" : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: surnameController,
          decoration: InputDecoration(labelText: "Apellido"),
          validator:
              (value) =>
                  value == null || value.isEmpty ? "Campo requerido" : null,
        ),
        const SizedBox(height: 20),
        CustomEmailField(
          label: "Correo electrónico",
          controller: emailController,
        ),
        const SizedBox(height: 20),
        CustomPasswordField(
          label: "Contraseña",
          controller: passwordController,
        ),
        const SizedBox(height: 20),
        CustomPasswordField(
          label: "Confirmar contraseña",
          controller: confirmPasswordController,
        ),
        const SizedBox(height: 30),
        CustomElevatedButton(label: "Siguiente", onPressed: onNext),
      ],
    );
  }
}

class StepTwo extends StatelessWidget {
  final CustomTextFieldController activationCodeController;
  final CustomTextFieldController peakVoltageController;
  final CustomTextFieldController temperatureRateController;
  final CustomTextFieldController solarPanelsController;
  final bool isLoading;
  final bool activationCodeInvalid;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const StepTwo({
    required this.activationCodeController,
    required this.peakVoltageController,
    required this.temperatureRateController,
    required this.solarPanelsController,
    required this.isLoading,
    required this.activationCodeInvalid,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Paso 2: Información del sistema",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: activationCodeController,
          decoration: InputDecoration(labelText: "Código de activación"),
          validator:
              (value) =>
                  value == null || value.isEmpty ? "Campo requerido" : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: peakVoltageController,
          decoration: InputDecoration(labelText: "Voltaje pico"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return "Campo requerido";
            final parsed = double.tryParse(value);
            if (parsed == null || parsed <= 0)
              return "Debe ser un número positivo";
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: temperatureRateController,
          decoration: InputDecoration(labelText: "Tasa de temperatura"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return "Campo requerido";
            final parsed = double.tryParse(value);
            if (parsed == null || parsed >= 0)
              return "Debe ser un número negativo";
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: solarPanelsController,
          decoration: InputDecoration(labelText: "Número de paneles solares"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return "Campo requerido";
            final parsed = int.tryParse(value);
            if (parsed == null || parsed <= 0)
              return "Debe ser un número entero mayor o igual que uno";
            return null;
          },
        ),
        const SizedBox(height: 30),
        if (activationCodeInvalid)
          const Text(
            "Código de activación no válido",
            style: TextStyle(color: Colors.red),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomElevatedButton(label: "Anterior", onPressed: onPrevious),
            isLoading
                ? const CircularProgressIndicator()
                : CustomElevatedButton(label: "Siguiente", onPressed: onNext),
          ],
        ),
      ],
    );
  }
}

class StepThree extends StatelessWidget {
  final CustomTextFieldController labelController;
  final CustomTextFieldController locationController;
  final List<LocationOption> locationOptions;
  final Future<void> Function(String) loadLocationOptions;
  final VoidCallback onPrevious;
  final VoidCallback onFinish;
  final bool isSubmitting;

  const StepThree({
    required this.labelController,
    required this.locationController,
    required this.locationOptions,
    required this.loadLocationOptions,
    required this.onPrevious,
    required this.onFinish,
    required this.isSubmitting,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Paso 3: Configuración del dispositivo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: labelController,
          decoration: InputDecoration(labelText: "Etiqueta"),
          validator:
              (value) =>
                  value == null || value.isEmpty ? "Campo requerido" : null,
        ),
        const SizedBox(height: 20),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            loadLocationOptions(textEditingValue.text);
            return locationOptions.map((option) => option.locationName);
          },
          onSelected: (String selection) {
            locationController.text = selection;
          },
          fieldViewBuilder: (
            context,
            controller,
            focusNode,
            onEditingComplete,
          ) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(labelText: "Ubicación"),
              onEditingComplete: onEditingComplete,
            );
          },
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomElevatedButton(label: "Anterior", onPressed: onPrevious),
            isSubmitting
                ? const CircularProgressIndicator()
                : CustomElevatedButton(label: "Finalizar", onPressed: onFinish),
          ],
        ),
      ],
    );
  }
}
