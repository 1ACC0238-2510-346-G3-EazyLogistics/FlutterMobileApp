import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_bloc.dart';
import '../../../core/theme/color_palette.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final void Function(String, String)? onProfileChanged;
  const ProfilePage({
    Key? key,
    this.name = '',
    this.email = '',
    this.onProfileChanged,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
            // Notificar cambios de perfil
            widget.onProfileChanged?.call(state.name, state.email);
          }
        },
        builder: (context, state) {
          if (state is ProfileUpdated) {
            _name = state.name;
            _email = state.email;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Editar Perfil'),
              backgroundColor: ColorPalette.primaryColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      initialValue: _name,
                      onSaved: (value) => _name = value ?? '',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese su nombre'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                      ),
                      initialValue: _email,
                      onSaved: (value) => _email = value ?? '',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese su correo'
                          : null,
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            context.read<ProfileBloc>().add(
                              UpdateProfile(name: _name, email: _email),
                            );
                            if (widget.onProfileChanged != null) {
                              widget.onProfileChanged!(_name, _email);
                            }
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
