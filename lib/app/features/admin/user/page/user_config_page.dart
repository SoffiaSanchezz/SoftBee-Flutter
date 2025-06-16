import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soft_bee/app/features/admin/user/models/user_models.dart';
import 'package:soft_bee/app/features/admin/user/services/auth_storage.dart';
import 'package:soft_bee/app/features/admin/user/services/user_service.dart';
import 'package:soft_bee/app/features/auth/data/service/user_service.dart';

class UserProfilePage extends StatefulWidget {
  final String authToken;

  const UserProfilePage({Key? key, required this.authToken}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserProfileService _userService = UserProfileService();
  late String _authToken;
  UserProfile? _userProfile;
  List<Apiary> _apiaries = [];
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isChangingPassword = false;
  bool _tokenVerified = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _authToken = widget.authToken;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _userService.getProfile(_authToken),
        _userService.getUserApiaries(_authToken),
      ]);

      if (!results[0]['success']) {
        throw Exception(results[0]['message'] ?? 'Error al cargar perfil');
      }

      if (!results[1]['success']) {
        throw Exception(results[1]['message'] ?? 'Error al cargar apiarios');
      }

      setState(() {
        _tokenVerified = true;
        _userProfile = UserProfile.fromJson(results[0]['data']);
        _apiaries =
            (results[1]['data'] as List)
                .map((a) => Apiary.fromJson(a))
                .toList();
        _nameController.text = _userProfile!.name;
        _emailController.text = _userProfile!.email;
        _phoneController.text = _userProfile!.phone;
      });
    } catch (e) {
      print('Error al cargar datos: $e');
      _showError('Error al cargar datos del usuario');
      await _logout();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await AuthStorage.deleteToken();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _updateProfile() async {
    if (!_validateProfileFields()) return;

    setState(() => _isLoading = true);
    try {
      final response = await _userService.updateProfile(
        token: _authToken,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      if (response['success']) {
        setState(() {
          _isEditing = false;
          _userProfile = UserProfile.fromJson(response['data']);
        });
        _showSuccess('Perfil actualizado correctamente');
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      _showError('Error al actualizar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateProfileFields() {
    if (_nameController.text.isEmpty) {
      _showError('El nombre no puede estar vacío');
      return false;
    }
    if (!_emailController.text.contains('@')) {
      _showError('Ingrese un correo válido');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      _showError('El teléfono no puede estar vacío');
      return false;
    }
    return true;
  }

  Future<void> _changePassword() async {
    if (!_validatePasswordFields()) return;

    setState(() => _isLoading = true);
    try {
      final response = await _userService.changePassword(
        token: _authToken,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (response['success']) {
        setState(() {
          _isChangingPassword = false;
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        });
        _showSuccess('Contraseña cambiada correctamente');
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      _showError('Error al cambiar contraseña: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validatePasswordFields() {
    if (_currentPasswordController.text.isEmpty) {
      _showError('Ingrese su contraseña actual');
      return false;
    }
    if (_newPasswordController.text.length < 6) {
      _showError('La nueva contraseña debe tener al menos 6 caracteres');
      return false;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showError('Las contraseñas no coinciden');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFFBC209).withOpacity(0.2),
            child: Icon(Icons.person, size: 50, color: Color(0xFFFBC209)),
          ),
          SizedBox(height: 16),
          Text(
            _userProfile?.name ?? 'Cargando...',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _userProfile?.email ?? 'Cargando...',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: Color(0xFFFBC209)),
              SizedBox(width: 8),
              Text(_userProfile?.phone ?? 'N/A'),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      _isEditing = !_isEditing;
                      _isChangingPassword = false;
                    }),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isEditing ? Colors.grey[300] : Color(0xFFFBC209),
                ),
                child: Text(
                  _isEditing ? 'Cancelar' : 'Editar Perfil',
                  style: TextStyle(
                    color: _isEditing ? Colors.black : Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      _isChangingPassword = !_isChangingPassword;
                      _isEditing = false;
                    }),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isChangingPassword ? Colors.grey[300] : Colors.white,
                  side: BorderSide(color: Color(0xFFFBC209)),
                ),
                child: Text(
                  _isChangingPassword ? 'Cancelar' : 'Cambiar Contraseña',
                  style: TextStyle(
                    color:
                        _isChangingPassword ? Colors.black : Color(0xFFFBC209),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildEditForm() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Teléfono'),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFBC209),
              minimumSize: Size(double.infinity, 50),
            ),
            child:
                _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                      'Guardar Cambios',
                      style: TextStyle(color: Colors.white),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _currentPasswordController,
            decoration: InputDecoration(labelText: 'Contraseña Actual'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            decoration: InputDecoration(labelText: 'Nueva Contraseña'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFBC209),
              minimumSize: Size(double.infinity, 50),
            ),
            child:
                _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                      'Cambiar Contraseña',
                      style: TextStyle(color: Colors.white),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiariesList() {
    if (_apiaries.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No hay apiarios registrados',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mis Apiarios (${_apiaries.length})',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ..._apiaries.map(
            (apiary) => ListTile(
              leading: Icon(Icons.hive, color: Color(0xFFFBC209)),
              title: Text(apiary.name),
              subtitle: Text(apiary.address),
              trailing: Text('${apiary.hiveCount} colmenas'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil', style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFBC209)),
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    if (_isEditing) _buildEditForm(),
                    if (_isChangingPassword) _buildPasswordForm(),
                    _buildApiariesList(),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
