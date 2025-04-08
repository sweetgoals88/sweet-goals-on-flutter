import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:prubea1app/api/api_interface.dart' as api;
import 'package:prubea1app/views/dashboard/dashboard_data_provider.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _previousPasswordController =
      TextEditingController();
  bool _isEdited = false;
  bool _isSaving = false;
  late String _originalEmail;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DashboardDataProvider>(context, listen: false);
    final data = provider.asUser();
    _nameController.text = data.name;
    _surnameController.text = data.surname;
    _emailController.text = data.email;
    _originalEmail = data.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _previousPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        await api.updateUserProfile(
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          email:
              _emailController.text.trim() == _originalEmail
                  ? ""
                  : _emailController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
          oldPassword: _previousPasswordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perfil actualizado correctamente")),
        );
        setState(() {
          _isEdited = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar el perfil: $e")),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        onChanged: () {
          setState(() {
            _isEdited = true;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Editar perfil",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: "Apellido"),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty ? "Campo requerido" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: "Nueva contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _previousPasswordController,
              decoration: const InputDecoration(
                labelText: "Contraseña anterior",
              ),
              obscureText: true,
              validator: (value) {
                if (_newPasswordController.text.isNotEmpty &&
                    (value == null || value.isEmpty)) {
                  return "Debes proporcionar la contraseña anterior";
                }
                if (value != null &&
                    value.isNotEmpty &&
                    _newPasswordController.text.isEmpty) {
                  return "Debes proporcionar una nueva contraseña";
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            _isSaving
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: _isEdited ? _saveChanges : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEdited ? Colors.green : Colors.grey,
                  ),
                  child: const Text(
                    "Guardar cambios",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  await api.logout();
                  if (!context.mounted) return;
                  context.go("/login");
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al cerrar sesión")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Cerrar sesión",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
