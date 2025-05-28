import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_bee/app/features/admin/user/controllers/user_config_controller.dart';
import 'package:soft_bee/core/entities/user.dart';

class UserProfilePage extends StatelessWidget {
  final int userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserConfigController()..loadUserData(userId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Perfil de Usuario')),
        body: Consumer<UserConfigController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.userName == null) {
              return const Center(child: Text('No se pudo cargar el usuario.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Hola, ${controller.userName}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Apiarios:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ...controller.apiarios.map((Apiario apiario) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Dirección: ${apiario.direccion}'),
                        subtitle: Text('Colmenas: ${apiario.cantidadColmenas}'),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
