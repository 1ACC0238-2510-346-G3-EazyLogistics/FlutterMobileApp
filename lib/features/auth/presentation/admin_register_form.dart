import 'package:flutter/material.dart';

class AdminRegisterForm extends StatefulWidget {
  final void Function(
    String hotelName,
    String userName,
    String email,
    String password,
  )
  onRegister;

  const AdminRegisterForm({super.key, required this.onRegister});

  @override
  State<AdminRegisterForm> createState() => _AdminRegisterFormState();
}

class _AdminRegisterFormState extends State<AdminRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _hotelName = '';
  String _userName = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre del hotel',
                ),
                onChanged: (value) => _hotelName = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                ),
                onChanged: (value) => _userName = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _email = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onRegister(_hotelName, _userName, _email, _password);
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
