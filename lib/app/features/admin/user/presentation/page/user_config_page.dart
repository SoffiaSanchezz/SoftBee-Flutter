import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_config_controller.dart';
import '../widgets/apiario_card.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({Key? key}) : super(key: key);

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  @override
  void initState() {
    super.initState();
    // Por ahora hardcodeado el userId, cámbialo según autenticación
    Provider.of<UserConfigController>(context, listen: false).loadUserData(1);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<UserConfigController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de usuario')),
      body:
          controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Hola, ${controller.userName ?? ''}!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...controller.apiarios
                      .map((apiario) => ApiarioCard(apiario: apiario))
                      .toList(),
                ],
              ),
    );
  }
}
