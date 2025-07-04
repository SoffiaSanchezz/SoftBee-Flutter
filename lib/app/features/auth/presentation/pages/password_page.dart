import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soft_bee/app/features/auth/data/service/user_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  // Colores personalizados
  final Color lightYellow = const Color(0xFFFFF9C4);
  final Color primaryYellow = const Color(0xFFFFC107);
  final Color accentYellow = const Color(0xFFFFA000);
  final Color darkYellow = const Color(0xFFFF8F00);
  final Color textDark = const Color(0xFF212121);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final response = await AuthService.requestPasswordReset(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Mostrar modal mejorado - más pequeño y centrado
    _showResultModal(
      success: response['success'],
      message: response['message'],
      email: _emailController.text.trim(),
    );
  }

  void _showResultModal({
    required bool success,
    required String message,
    required String email,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildModalContent(success, message, email),
        );
      },
    );
  }

  Widget _buildModalContent(bool success, String message, String email) {
    return Container(
      // Hacer el modal más pequeño
      constraints: const BoxConstraints(maxWidth: 320, maxHeight: 400),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono más pequeño
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        success
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: success ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    success ? Icons.mark_email_read : Icons.error_outline,
                    size: 32,
                    color: success ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Título más compacto
          Text(
            success ? '¡Correo Enviado!' : 'Error',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Contenido simplificado
          if (success) ...[
            Text(
              'Enlace enviado a:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textDark.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: lightYellow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryYellow.withOpacity(0.3)),
              ),
              child: Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkYellow,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            // Instrucciones más concisas
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Text(
                'Revisa tu bandeja de entrada y spam.\nEl enlace expira en 24 horas.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.blue.withOpacity(0.8),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ] else ...[
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: textDark.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 20),

          // Botones más compactos
          if (success) ...[
            // Solo un botón principal para éxito
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar modal
                  Navigator.of(context).pop(); // Regresar a login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  'Entendido',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Botón secundario más pequeño
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar modal
                _resetPassword(); // Reenviar
              },
              child: Text(
                'Reenviar correo',
                style: GoogleFonts.poppins(
                  color: darkYellow,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ] else ...[
            // Para errores, solo botón de reintentar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryYellow,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // El resto de los métodos permanecen igual...
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

  // Resto de métodos helper mantienen la misma estructura...
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
                      Icons.emoji_nature,
                      size: logoSize * 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  'SoftBee',
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
                    'Gestión de Apiarios',
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
                          Icons.emoji_nature,
                          size: logoSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                    Text(
                      'SoftBee',
                      style: GoogleFonts.poppins(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Gestión de Apiarios',
                      style: GoogleFonts.poppins(
                        fontSize: subtitleSize,
                        color: textDark.withOpacity(0.7),
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
                          Icons.emoji_nature,
                          size: logoSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 0.5),
                      Text(
                        'SoftBee',
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

  // Resto de métodos helper (mantienen la misma estructura)
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
        style: const TextStyle(color: Colors.black),
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
            borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
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
        gradient: LinearGradient(
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

  Widget _buildBackToLoginButton(double fontSize) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFFFC107), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_back, color: Color(0xFFFF8F00), size: 20),
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
