import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores originales adaptados
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  int _currentStep = 0;

  // Variables para validaciones en tiempo real
  String? _nombreError;
  String? _correoError;
  String? _passError;
  String? _confirmPassError;
  bool _showValidation = false;

  // Lista de apiarios (adaptado de tu lógica original)
  List<ApiaryData> _apiaries = [ApiaryData()];

  // Colores del tema
  static const Color primaryYellow = Color(0xFFFFD100);
  static const Color accentYellow = Color(0xFFFFAB00);
  static const Color lightYellow = Color(0xFFFFF8E1);
  static const Color darkYellow = Color(0xFFF9A825);
  static const Color textDark = Color(0xFF333333);

  // Tu función original de registro adaptada
  Future<void> registrarUsuario() async {
    final url = Uri.parse("http://192.168.1.10:8000/usuarios/register");

    try {
      setState(() => _isLoading = true);
      final apiariesData =
          _apiaries
              .map(
                (apiary) => {
                  "direccion": apiary.addressController.text.trim(),
                  "cantidad_colmenas":
                      int.tryParse(apiary.hiveCountController.text) ?? 0,
                },
              )
              .toList();

      // Ajusta requestBody
      final requestBody =
          _apiaries.length == 1
              ? {
                "nombre": nombreCtrl.text.trim(),
                "correo": correoCtrl.text.trim(),
                "contraseña": passCtrl.text,
                "apiarios": [
                  {
                    "direccion": _apiaries[0].addressController.text.trim(),
                    "cantidad_colmenas":
                        int.tryParse(_apiaries[0].hiveCountController.text) ??
                        0,
                  },
                ],
              }
              : {
                "nombre": nombreCtrl.text.trim(),
                "correo": correoCtrl.text.trim(),
                "contraseña": passCtrl.text,
                "apiarios": apiariesData,
              };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Mostrar alerta de éxito
        _showSuccessDialog(
          decodedResponse['msg'] ?? 'Usuario registrado exitosamente',
        );
      } else {
        // Mostrar alerta de error
        _showErrorDialog(
          decodedResponse['detail'] ?? 'Error al registrar usuario',
        );
      }
    } catch (e) {
      // Mostrar alerta de error de conexión
      _showErrorDialog('Error de conexión: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Función para mostrar alerta de éxito
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '¡Registro Exitoso!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textDark.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Color(0xFF4CAF50)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar dialog
                    Navigator.of(context).pop(); // Regresar a pantalla anterior
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Continuar',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para mostrar alerta de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Error en el Registro',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textDark.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.red, Color(0xFFE53935)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Intentar de nuevo',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Funciones de validación en tiempo real
  void _validateNombre(String value) {
    setState(() {
      if (value.isEmpty) {
        _nombreError = 'El nombre es requerido';
      } else if (value.length < 2) {
        _nombreError = 'El nombre debe tener al menos 2 caracteres';
      } else {
        _nombreError = null;
      }
    });
  }

  void _validateCorreo(String value) {
    setState(() {
      if (value.isEmpty) {
        _correoError = 'El correo es requerido';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _correoError = 'Ingresa un correo válido';
      } else {
        _correoError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passError = 'La contraseña es requerida';
      } else if (value.length < 6) {
        _passError = 'La contraseña debe tener al menos 6 caracteres';
      } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
        _passError = 'Debe contener al menos una letra y un número';
      } else {
        _passError = null;
      }

      // Revalidar confirmación de contraseña si ya tiene texto
      if (confirmPassCtrl.text.isNotEmpty) {
        _validateConfirmPassword(confirmPassCtrl.text);
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPassError = 'Confirma tu contraseña';
      } else if (value != passCtrl.text) {
        _confirmPassError = 'Las contraseñas no coinciden';
      } else {
        _confirmPassError = null;
      }
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? errorText,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            obscureText: isPassword && !_isPasswordVisible,
            keyboardType: keyboardType,
            style: const TextStyle(color: textDark),
            onChanged: (value) {
              if (_showValidation && onChanged != null) {
                onChanged(value);
              }
            },
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              labelStyle: TextStyle(
                color: errorText != null ? Colors.red : darkYellow,
              ),
              prefixIcon: Icon(
                icon,
                color: errorText != null ? Colors.red : primaryYellow,
              ),
              suffixIcon:
                  isPassword
                      ? IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: errorText != null ? Colors.red : primaryYellow,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )
                      : (errorText != null
                          ? const Icon(Icons.error_outline, color: Colors.red)
                          : (controller.text.isNotEmpty &&
                                  errorText == null &&
                                  _showValidation
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                              : null)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color:
                      errorText != null
                          ? Colors.red.withOpacity(0.5)
                          : primaryYellow.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : primaryYellow,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            validator: validator,
          ),
        ),
        // Mensaje de error debajo del campo
        if (errorText != null && _showValidation)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorText,
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Mensaje de éxito
        if (errorText == null && controller.text.isNotEmpty && _showValidation)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Campo válido',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    correoCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    for (final apiary in _apiaries) {
      apiary.addressController.dispose();
      apiary.hiveCountController.dispose();
    }
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

  Widget _buildDesktopLayout(
    BuildContext context,
    double width,
    double height,
  ) {
    final logoSize = width * 0.12;
    final titleSize = width * 0.025;
    final subtitleSize = width * 0.015;
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
                      Icons.hive,
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
                    'Crea tu cuenta de apicultor',
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
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Registro',
                          style: GoogleFonts.poppins(
                            fontSize: titleSize * 0.9,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: verticalSpacing),
                        _buildRegistrationStepper(width, height, subtitleSize),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    double width,
    double height,
    bool isSmallScreen,
  ) {
    final logoSize = width * (isSmallScreen ? 0.30 : 0.10);
    final titleSize = width * (isSmallScreen ? 0.06 : 0.05);
    final subtitleSize = width * (isSmallScreen ? 0.04 : 0.03);
    final verticalSpacing = height * 0.02;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo y encabezado
            SizedBox(
              height: height * 0.25,
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
                          Icons.hive,
                          size: logoSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                    Text(
                      'Registro SoftBee',
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
            ),
            // Formulario de registro
            Form(
              key: _formKey,
              child: _buildRegistrationStepper(width, height, subtitleSize),
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

  Widget _buildLandscapeLayout(
    BuildContext context,
    double width,
    double height,
  ) {
    final logoSize = height * 0.25;
    final titleSize = height * 0.06;
    final subtitleSize = height * 0.035;
    final horizontalPadding = width * 0.05;
    final verticalSpacing = height * 0.03;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda: Logo
            SizedBox(
              width: width * 0.3,
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
                      Icons.hive,
                      size: logoSize * 0.4,
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
              child: Form(
                key: _formKey,
                child: _buildRegistrationStepper(width, height, subtitleSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationStepper(
    double width,
    double height,
    double fontSize,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: primaryYellow, secondary: accentYellow),
      ),
      child: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          final isLastStep = _currentStep == 1;

          if (isLastStep) {
            if (_formKey.currentState!.validate()) {
              registrarUsuario();
            }
          } else {
            // Activar validaciones en tiempo real
            setState(() {
              _showValidation = true;
            });

            // Validar todos los campos del paso actual
            _validateNombre(nombreCtrl.text);
            _validateCorreo(correoCtrl.text);
            _validatePassword(passCtrl.text);
            _validateConfirmPassword(confirmPassCtrl.text);

            // Verificar si hay errores
            if (_nombreError == null &&
                _correoError == null &&
                _passError == null &&
                _confirmPassError == null &&
                nombreCtrl.text.isNotEmpty &&
                correoCtrl.text.isNotEmpty &&
                passCtrl.text.isNotEmpty &&
                confirmPassCtrl.text.isNotEmpty) {
              setState(() {
                _currentStep += 1;
              });
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          } else {
            Navigator.of(context).pop();
          }
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == 1;

          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                // Botón Continuar/Registrar
                Expanded(
                  child: Container(
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
                      onPressed: details.onStepContinue,
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
                          _isLoading && isLastStep
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
                                    isLastStep
                                        ? Icons.check_circle
                                        : Icons.navigate_next,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isLastStep ? 'Registrarse' : 'Continuar',
                                    style: GoogleFonts.poppins(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Botón Cancelar/Atrás
                Expanded(
                  child: OutlinedButton(
                    onPressed: details.onStepCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryYellow, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _currentStep > 0 ? 'Atrás' : 'Cancelar',
                      style: GoogleFonts.poppins(
                        color: darkYellow,
                        fontWeight: FontWeight.normal,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          // Paso 1: Información personal
          Step(
            title: Text(
              'Información Personal',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            content: Column(
              children: [
                _buildTextField(
                  controller: nombreCtrl,
                  label: 'Nombre completo',
                  hint: 'Ingresa tu nombre',
                  icon: Icons.person_outline,
                  errorText: _nombreError,
                  onChanged: _validateNombre,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: correoCtrl,
                  label: 'Correo electrónico',
                  hint: 'ejemplo@correo.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _correoError,
                  onChanged: _validateCorreo,
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
                const SizedBox(height: 16),
                _buildTextField(
                  controller: passCtrl,
                  label: 'Contraseña',
                  hint: 'Crea una contraseña',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  errorText: _passError,
                  onChanged: _validatePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: confirmPassCtrl,
                  label: 'Confirmar contraseña',
                  hint: 'Repite tu contraseña',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  errorText: _confirmPassError,
                  onChanged: _validateConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirma tu contraseña';
                    }
                    if (value != passCtrl.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          // Paso 2: Información de apiarios
          Step(
            title: Text(
              'Información de Apiarios',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            content: Column(
              children: [
                Text(
                  'Agrega información sobre tus apiarios',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: textDark.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                // Lista de apiarios
                ..._apiaries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final apiary = entry.value;

                  return _buildApiaryCard(
                    apiary: apiary,
                    index: index,
                    onRemove: () => _removeApiary(index),
                    showRemoveButton: _apiaries.length > 1,
                  );
                }).toList(),
                // Botón para agregar apiario
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: OutlinedButton.icon(
                    onPressed: _addApiary,
                    icon: const Icon(Icons.add, color: darkYellow),
                    label: Text(
                      'Agregar otro apiario',
                      style: GoogleFonts.poppins(
                        color: darkYellow,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryYellow, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget _buildApiaryCard({
    required ApiaryData apiary,
    required int index,
    required VoidCallback onRemove,
    required bool showRemoveButton,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryYellow.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la tarjeta
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Apiario ${index + 1}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: darkYellow,
                  ),
                ),
                if (showRemoveButton)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    tooltip: 'Eliminar apiario',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTextField(
                  controller: apiary.addressController,
                  label: 'Ubicación del apiario',
                  hint: 'Ej: Camino Rural Km 5, Sector Las Abejas',
                  icon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la ubicación';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: apiary.hiveCountController,
                  label: 'Cantidad de colmenas',
                  hint: 'Ej: 25',
                  icon: Icons.grid_view_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la cantidad';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Ingresa un número válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(double width, double fontSize) {
    return Column(
      children: [
        const SizedBox(height: 20),
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

  void _addApiary() {
    setState(() {
      _apiaries.add(ApiaryData());
    });
  }

  void _removeApiary(int index) {
    if (_apiaries.length > 1) {
      setState(() {
        _apiaries.removeAt(index);
      });
    }
  }
}

// Clase para almacenar datos de apiario
class ApiaryData {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController hiveCountController = TextEditingController();

  String get address => addressController.text;
  int get hiveCount => int.tryParse(hiveCountController.text) ?? 0;
}
