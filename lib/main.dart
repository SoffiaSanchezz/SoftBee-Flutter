import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegúrate de tenerlo importado
import 'package:soft_bee/app/features/admin/user/controllers/user_config_controller.dart';
import 'package:soft_bee/app/features/auth/presentation/pages/login_page.dart';
import 'package:soft_bee/app/features/auth/presentation/widgets/menu_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserConfigController()),
        // Agrega aquí otros providers si los tienes
      ],
      child: MaterialApp(
        title: 'Login App',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {"/home": (context) => MenuScreen()},
      ),
    );
  }
}
