import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RegistrarCosechaScreen extends StatefulWidget {
  final String colmenaNombre;

  const RegistrarCosechaScreen({super.key, required this.colmenaNombre});

  @override
  State<RegistrarCosechaScreen> createState() => _RegistrarCosechaScreenState();
}

class _RegistrarCosechaScreenState extends State<RegistrarCosechaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _notasController = TextEditingController();

  DateTime _fechaCosecha = DateTime.now();
  String _calidadMiel = 'alta';
  double _progreso = 0.0;
  final double _metaProduccion = 50.0;

  @override
  void initState() {
    super.initState();
    _cantidadController.addListener(_actualizarProgreso);
  }

  void _actualizarProgreso() {
    final cantidad = double.tryParse(_cantidadController.text) ?? 0.0;
    setState(() {
      _progreso = (cantidad / _metaProduccion).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      appBar: AppBar(
        title: Text(
              'Registrar Cosecha',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(
              begin: -0.2,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOutQuad,
            ),
        backgroundColor: Colors.amber[600],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => _mostrarAyuda(context),
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
        ],
      ),
      backgroundColor: const Color(0xFFF9F8F6),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1200 : (isTablet ? 900 : double.infinity),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(isDesktop, isTablet)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 600.ms,
                          curve: Curves.easeOutQuad,
                        ),
                    SizedBox(height: isDesktop ? 32 : 20),

                    _buildFormularioSection(isDesktop, isTablet)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: isDesktop ? 24 : 16),

                    _buildProgresoSection(isDesktop, isTablet)
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: isDesktop ? 24 : 16),

                    _buildConsejosCard(isDesktop, isTablet)
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: isDesktop ? 32 : 20),

                    _buildActionButtons(context, isDesktop, isTablet)
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 20)),
      decoration: BoxDecoration(
        color: Colors.amber[600],
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                ),
                child: Icon(
                      Icons.scale,
                      size: isDesktop ? 40 : 32,
                      color: Colors.amber[700],
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .rotate(begin: -0.05, end: 0.05, duration: 2000.ms),
              ),
              SizedBox(width: isDesktop ? 24 : 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.colmenaNombre,
                      style: GoogleFonts.poppins(
                        fontSize: isDesktop ? 28 : (isTablet ? 26 : 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Registro de Cosecha',
                      style: GoogleFonts.poppins(
                        fontSize: isDesktop ? 16 : 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 32 : 20),

          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeaderStat(
                  icon: Icons.calendar_today_outlined,
                  label: 'Temporada',
                  value: 'Primavera 2024',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.track_changes_outlined,
                  label: 'Meta',
                  value: '${_metaProduccion.toInt()} Kg',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.scale_outlined,
                  label: 'Acumulado',
                  value:
                      '${_cantidadController.text.isEmpty ? "0" : _cantidadController.text} Kg',
                  isDesktop: isDesktop,
                ),
              ],
            )
          else
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildHeaderStat(
                  icon: Icons.calendar_today_outlined,
                  label: 'Temporada',
                  value: 'Primavera 2024',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.track_changes_outlined,
                  label: 'Meta',
                  value: '${_metaProduccion.toInt()} Kg',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.scale_outlined,
                  label: 'Acumulado',
                  value:
                      '${_cantidadController.text.isEmpty ? "0" : _cantidadController.text} Kg',
                  isDesktop: isDesktop,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String label,
    required String value,
    required bool isDesktop,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isDesktop ? 24 : 20, color: Colors.white),
          SizedBox(height: isDesktop ? 8 : 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 14 : 12,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioSection(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.amber[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.scale_outlined,
                color: Colors.amber[800],
                size: isDesktop ? 24 : 20,
              ),
              SizedBox(width: isDesktop ? 12 : 8),
              Text(
                'Detalles de la Cosecha',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 20),

          // Fecha de Cosecha
          _buildDateField(
            label: 'Fecha de Cosecha',
            icon: Icons.calendar_today_outlined,
            selectedDate: _fechaCosecha,
            onDateSelected: (date) => setState(() => _fechaCosecha = date),
            isDesktop: isDesktop,
          ),

          SizedBox(height: isDesktop ? 20 : 16),

          // Cantidad
          _buildNumberField(
            label: 'Cantidad (Kg)',
            icon: Icons.scale_outlined,
            controller: _cantidadController,
            suffix: 'Kg',
            isDesktop: isDesktop,
          ),

          SizedBox(height: isDesktop ? 20 : 16),

          // Calidad
          _buildDropdownField(
            label: 'Calidad de la Miel',
            icon: Icons.star_outline,
            value: _calidadMiel,
            items: const [
              {'value': 'alta', 'label': 'Alta'},
              {'value': 'media', 'label': 'Media'},
              {'value': 'baja', 'label': 'Baja'},
            ],
            onChanged: (value) => setState(() => _calidadMiel = value!),
            isDesktop: isDesktop,
          ),

          SizedBox(height: isDesktop ? 20 : 16),

          // Notas
          _buildTextAreaField(
            label: 'Notas Adicionales',
            icon: Icons.notes_outlined,
            controller: _notasController,
            hint: 'Ingrese cualquier observación relevante sobre la cosecha...',
            isDesktop: isDesktop,
          ),
        ],
      ),
    );
  }

  Widget _buildProgresoSection(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.amber[200]!, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso hacia la Meta',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 20 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 16 : 12,
                  vertical: isDesktop ? 8 : 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber[300]!),
                ),
                child: Text(
                  '${(_progreso * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 20),

          LinearProgressIndicator(
            value: _progreso,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[600]!),
            minHeight: isDesktop ? 12 : 8,
          ),

          SizedBox(height: isDesktop ? 16 : 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 Kg',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 16 : 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                'Meta: ${_metaProduccion.toInt()} Kg',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 16 : 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsejosCard(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.amber[700],
            size: isDesktop ? 24 : 20,
          ),
          SizedBox(width: isDesktop ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consejos para el registro',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
                SizedBox(height: isDesktop ? 8 : 4),
                Text(
                  'Registrar con precisión la cantidad y calidad de la miel ayuda a mantener un seguimiento adecuado de la productividad de cada colmena y planificar futuras temporadas.',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 14 : 12,
                    color: Colors.amber[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      children: [
        if (isDesktop || isTablet)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 16 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                  ),
                ),
              ),
              SizedBox(width: isDesktop ? 16 : 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _guardarCosecha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 16 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Guardar Registro',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarCosecha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Guardar Registro',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Widgets auxiliares para los campos del formulario
  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: isDesktop ? 20 : 18, color: Colors.amber[700]),
            SizedBox(width: isDesktop ? 8 : 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 8 : 6),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );
            if (date != null) onDateSelected(date);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isDesktop ? 16 : 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: isDesktop ? 20 : 18,
                  color: Colors.grey[600],
                ),
                SizedBox(width: isDesktop ? 12 : 8),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 16 : 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String suffix,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: isDesktop ? 20 : 18, color: Colors.amber[700]),
            SizedBox(width: isDesktop ? 8 : 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 8 : 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber[600]!),
            ),
            contentPadding: EdgeInsets.all(isDesktop ? 16 : 12),
          ),
          style: GoogleFonts.poppins(fontSize: isDesktop ? 16 : 14),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            if (double.tryParse(value) == null) {
              return 'Ingrese un número válido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<Map<String, String>> items,
    required Function(String?) onChanged,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: isDesktop ? 20 : 18, color: Colors.amber[700]),
            SizedBox(width: isDesktop ? 8 : 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 8 : 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber[600]!),
            ),
            contentPadding: EdgeInsets.all(isDesktop ? 16 : 12),
          ),
          items:
              items.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: Text(
                    item['label']!,
                    style: GoogleFonts.poppins(fontSize: isDesktop ? 16 : 14),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: isDesktop ? 20 : 18, color: Colors.amber[700]),
            SizedBox(width: isDesktop ? 8 : 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 8 : 6),
        TextFormField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber[600]!),
            ),
            contentPadding: EdgeInsets.all(isDesktop ? 16 : 12),
          ),
          style: GoogleFonts.poppins(fontSize: isDesktop ? 16 : 14),
        ),
      ],
    );
  }

  void _guardarCosecha() {
    if (_formKey.currentState!.validate()) {
      // Aquí implementarías la lógica para guardar la cosecha
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cosecha registrada exitosamente',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Ayuda - Registro de Cosecha',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Complete todos los campos para registrar la cosecha de miel. La cantidad se medirá en kilogramos y el progreso se calculará automáticamente basado en la meta de producción.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Entendido',
                  style: GoogleFonts.poppins(color: Colors.amber[600]),
                ),
              ),
            ],
          ),
    );
  }
}
