import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_bee/app/features/admin/user/controllers/user_config_controller.dart';
import 'package:soft_bee/app/features/admin/user/page/user_config_page.dart';
import 'package:soft_bee/app/features/admin/user/services/auth_storage.dart';
import 'package:soft_bee/app/features/auth/data/service/user_service.dart';
import 'package:soft_bee/app/features/auth/presentation/pages/password_page.dart';
import 'package:soft_bee/app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:soft_bee/app/features/auth/presentation/pages/login_page.dart';
import 'package:soft_bee/app/features/auth/presentation/widgets/menu_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserConfigController()),
      ],
      child: MaterialApp(
        title: 'SoftBee',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: AuthStorage.hasToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return snapshot.data == true ? MenuScreen() : LoginPage();
          },
        ),
        routes: {
          "/home": (context) => MenuScreen(),
          "/forgot-password": (context) => const ForgotPasswordPage(),
          "/profile":
              (context) => FutureBuilder(
                future: AuthStorage.getToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    return FutureBuilder(
                      future: AuthService.verifyToken(snapshot.data!),
                      builder: (context, verifySnapshot) {
                        if (verifySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (verifySnapshot.data == true) {
                          return UserProfilePage(authToken: snapshot.data!);
                        } else {
                          AuthStorage.deleteToken();
                          return LoginPage();
                        }
                      },
                    );
                  }

                  return LoginPage();
                },
              ),
          "/reset-password": (context) {
            final uri = Uri.parse(ModalRoute.of(context)!.settings.name ?? '');
            final token = uri.queryParameters['token'];
            return token != null
                ? ResetPasswordPage(token: token)
                : LoginPage();
          },
        },
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/reset-password') ?? false) {
            final uri = Uri.parse(settings.name!);
            final token = uri.queryParameters['token'];
            return MaterialPageRoute(
              builder:
                  (context) =>
                      token != null
                          ? ResetPasswordPage(token: token)
                          : LoginPage(),
            );
          }
          return null;
        },
      ),
    );
  }
}
