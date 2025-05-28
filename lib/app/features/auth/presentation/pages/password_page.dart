import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  // Colores personalizados del diseño (mismos que el login)
  static const Color primaryYellow = Color(0xFFFFD100);
  static const Color accentYellow = Color(0xFFFFAB00);
  static const Color lightYellow = Color(0xFFFFF8E1);
  static const Color darkYellow = Color(0xFFF9A825);
  static const Color textDark = Color(0xFF333333);

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulación de envío de correo de recuperación
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Se ha enviado un enlace de recuperación a tu correo',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Regresar a la pantalla de login después de 3 segundos
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final isSmallScreen = width < 600;
          final isLandscape = width > height;
          final isDesktop = width > 1024;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [lightYellow, Colors.white],
              ),
            ),
            child: SafeArea(
              child:
                  isDesktop
                      ? _buildDesktopLayout(context, width, height)
                      : (isLandscape && isSmallScreen
                          ? _buildLandscapeLayout(context, width, height)
                          : _buildPortraitLayout(
                            context,
                            width,
                            height,
                            isSmallScreen,
                          )),
            ),
          );
        },
      ),
    );
  }

  // Layout para escritorio
  Widget _buildDesktopLayout(
    BuildContext context,
    double width,
    double height,
  ) {
    final logoSize = width * 0.12;
    final titleSize = width * 0.025;
    final subtitleSize = width * 0.015;
    final buttonHeight = height * 0.07;
    final verticalSpacing = height * 0.025;

    return Row(
      children: [
        // Panel izquierdo - Logo y branding
        Container(
          width: width * 0.4,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [lightYellow, Colors.white.withOpacity(0.9)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(5, 0),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    height: logoSize,
                    width: logoSize,
                    decoration: BoxDecoration(
                      color: primaryYellow,
                      borderRadius: BorderRadius.circular(logoSize * 0.3),
                      boxShadow: [
                        BoxShadow(
                          color: darkYellow.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: logoSize * 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  'Recuperación',
                  style: GoogleFonts.poppins(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: verticalSpacing * 0.5),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: height * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: lightYellow,
                    borderRadius: BorderRadius.circular(height * 0.02),
                    border: Border.all(color: primaryYellow, width: 2),
                  ),
                  child: Text(
                    'Recupera el acceso a tu cuenta',
                    style: GoogleFonts.poppins(
                      fontSize: subtitleSize,
                      color: darkYellow,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Panel derecho - Formulario
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.05,
              ),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: _buildForgotPasswordForm(
                    titleSize * 0.9,
                    subtitleSize,
                    buttonHeight,
                    verticalSpacing,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Layout para orientación vertical
  Widget _buildPortraitLayout(
    BuildContext context,
    double width,
    double height,
    bool isSmallScreen,
  ) {
    final logoSize = width * (isSmallScreen ? 0.20 : 0.1);
    final titleSize = width * (isSmallScreen ? 0.06 : 0.04);
    final subtitleSize = width * (isSmallScreen ? 0.04 : 0.02);
    final buttonHeight = height * 0.07;
    final verticalSpacing = height * 0.02;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón de regreso
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: darkYellow),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            SizedBox(height: verticalSpacing),

            // Logo y encabezado
            SizedBox(
              height: height * 0.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Container(
                        height: logoSize,
                        width: logoSize,
                        decoration: BoxDecoration(
                          color: primaryYellow,
                          borderRadius: BorderRadius.circular(logoSize * 0.3),
                          boxShadow: [
                            BoxShadow(
                              color: darkYellow.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: logoSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                    Text(
                      'Recuperar Contraseña',
                      style: GoogleFonts.poppins(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Formulario
            _buildForgotPasswordForm(
              titleSize * 0.7,
              subtitleSize,
              buttonHeight,
              verticalSpacing,
            ),

            // Footer
            Padding(
              padding: EdgeInsets.only(top: verticalSpacing),
              child: _buildFooter(width, subtitleSize),
            ),
          ],
        ),
      ),
    );
  }

  // Layout para orientación horizontal
  Widget _buildLandscapeLayout(
    BuildContext context,
    double width,
    double height,
  ) {
    final logoSize = height * 0.25;
    final titleSize = height * 0.06;
    final subtitleSize = height * 0.035;
    final buttonHeight = height * 0.12;
    final horizontalPadding = width * 0.05;
    final verticalSpacing = height * 0.03;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          children: [
            // Botón de regreso
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: darkYellow),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            SizedBox(height: verticalSpacing),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: Logo
                SizedBox(
                  width: width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: logoSize,
                        width: logoSize,
                        decoration: BoxDecoration(
                          color: primaryYellow,
                          borderRadius: BorderRadius.circular(logoSize * 0.25),
                          boxShadow: [
                            BoxShadow(
                              color: darkYellow.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: logoSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 0.5),
                      Text(
                        'Recuperación',
                        style: GoogleFonts.poppins(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: width * 0.05),

                // Columna derecha: Formulario
                Expanded(
                  child: _buildForgotPasswordForm(
                    titleSize * 0.8,
                    subtitleSize,
                    buttonHeight,
                    verticalSpacing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Formulario de recuperación reutilizable
  Widget _buildForgotPasswordForm(
    double titleSize,
    double subtitleSize,
    double buttonHeight,
    double verticalSpacing,
  ) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icono y título
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: lightYellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryYellow, width: 2),
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 32,
                    color: darkYellow,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  'Recuperar Contraseña',
                  style: GoogleFonts.poppins(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing * 0.5),
                Text(
                  'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: subtitleSize,
                    color: textDark.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),

            SizedBox(height: verticalSpacing * 1.5),

            // Campo de email
            _buildTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hint: 'ejemplo@correo.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
            ),

            SizedBox(height: verticalSpacing * 1.5),

            // Botón de envío
            SizedBox(
              height: buttonHeight,
              child: _buildSendButton(subtitleSize),
            ),

            SizedBox(height: verticalSpacing),

            // Separador
            _buildDivider(),

            SizedBox(height: verticalSpacing),

            // Botón de regreso al login
            SizedBox(
              height: buttonHeight * 0.8,
              child: _buildBackToLoginButton(subtitleSize),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: textDark),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: darkYellow),
          prefixIcon: Icon(icon, color: primaryYellow),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: primaryYellow.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryYellow, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }

  // Widget para el botón de envío
  Widget _buildSendButton(double fontSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryYellow.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: const LinearGradient(
          colors: [primaryYellow, accentYellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: (_isLoading || _emailSent) ? null : _resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _emailSent ? Icons.check_circle : Icons.send,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _emailSent ? 'Enlace Enviado' : 'Enviar Enlace',
                      style: GoogleFonts.poppins(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  // Widget para el separador
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: primaryYellow.withOpacity(0.5), thickness: 1.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightYellow,
              shape: BoxShape.circle,
              border: Border.all(color: primaryYellow, width: 1.5),
            ),
            child: Text(
              'O',
              style: GoogleFonts.poppins(
                color: darkYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Divider(color: primaryYellow.withOpacity(0.5), thickness: 1.5),
        ),
      ],
    );
  }

  // Widget para el botón de regreso al login
  Widget _buildBackToLoginButton(double fontSize) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryYellow, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_back, color: darkYellow, size: 20),
          const SizedBox(width: 8),
          Text(
            'Volver al inicio de sesión',
            style: GoogleFonts.poppins(
              color: darkYellow,
              fontWeight: FontWeight.normal,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para el footer
  Widget _buildFooter(double width, double fontSize) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightYellow.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryYellow.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: darkYellow, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Si no recibes el correo, revisa tu carpeta de spam o contacta con soporte.',
                  style: GoogleFonts.poppins(
                    color: darkYellow,
                    fontSize: fontSize * 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          '© ${DateTime.now().year} SoftBee. Todos los derechos reservados.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: textDark.withOpacity(0.6),
            fontSize: fontSize * 0.7,
          ),
        ),
      ],
    );
  }
}
