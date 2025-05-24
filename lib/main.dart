import 'package:flutter/material.dart';
import 'package:soft_bee/app/features/auth/presentation/pages/register_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false, // Quita el banner de debug
      home: RegisterPage(), // Aquí llamas tu Login personalizado
      // routes: {
      //   "/admin": (context) => , // Agrega tu pantalla de destino
      // },
    );
  }
}
