import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TratamientoScreen extends StatefulWidget {
  final String colmenaNombre;

  const TratamientoScreen({super.key, required this.colmenaNombre});

  @override
  State<TratamientoScreen> createState() => _TratamientoScreenState();
}

class _TratamientoScreenState extends State<TratamientoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dosisController = TextEditingController();
  final _observacionesController = TextEditingController();

  DateTime _fechaInicio = DateTime.now();
  DateTime? _fechaFin;
  String _tipoTratamiento = 'acido_oxalico';
  String _motivoTratamiento = 'preventivo';
  String _unidadDosis = 'ml';
  bool _crearRecordatorio = true;

  @override
  void dispose() {
    _dosisController.dispose();
    _observacionesController.dispose();
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
              'Registro de Tratamiento',
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
        backgroundColor: Colors.red[700],
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

                    _buildAlertaImportante(isDesktop, isTablet)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: isDesktop ? 24 : 16),

                    _buildFormularioSection(isDesktop, isTablet)
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: isDesktop ? 24 : 16),

                    _buildRecomendacionesCard(isDesktop, isTablet)
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
        color: Colors.red[700],
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
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
                      Icons.medical_services,
                      size: isDesktop ? 40 : 32,
                      color: Colors.red[700],
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
                      'Registro de Tratamiento Sanitario',
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
                  label: 'Último Tratamiento',
                  value: '15-03-2024',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.health_and_safety_outlined,
                  label: 'Estado Sanitario',
                  value: 'Preventivo',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.medical_services_outlined,
                  label: 'Tratamientos 2024',
                  value: '2',
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
                  label: 'Último Tratamiento',
                  value: '15-03-2024',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.health_and_safety_outlined,
                  label: 'Estado Sanitario',
                  value: 'Preventivo',
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.medical_services_outlined,
                  label: 'Tratamientos 2024',
                  value: '2',
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

  Widget _buildAlertaImportante(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: Colors.amber[700],
            size: isDesktop ? 24 : 20,
          ),
          SizedBox(width: isDesktop ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importante',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
                SizedBox(height: isDesktop ? 8 : 4),
                Text(
                  'Recuerda respetar los tiempos de espera entre tratamiento y cosecha para garantizar la calidad de la miel.',
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
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: Colors.red[800],
                size: isDesktop ? 24 : 20,
              ),
              SizedBox(width: isDesktop ? 12 : 8),
              Text(
                'Detalles del Tratamiento',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 20),

          // Tipo de Tratamiento
          _buildTipoTratamientoSection(isDesktop),

          SizedBox(height: isDesktop ? 20 : 16),

          // Fechas
          if (isDesktop || isTablet)
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Fecha de Inicio',
                    icon: Icons.calendar_today_outlined,
                    selectedDate: _fechaInicio,
                    onDateSelected:
                        (date) => setState(() => _fechaInicio = date),
                    isDesktop: isDesktop,
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Expanded(
                  child: _buildDateField(
                    label: 'Fecha de Finalización',
                    icon: Icons.event_outlined,
                    selectedDate: _fechaFin,
                    onDateSelected: (date) => setState(() => _fechaFin = date),
                    isDesktop: isDesktop,
                    isOptional: true,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildDateField(
                  label: 'Fecha de Inicio',
                  icon: Icons.calendar_today_outlined,
                  selectedDate: _fechaInicio,
                  onDateSelected: (date) => setState(() => _fechaInicio = date),
                  isDesktop: isDesktop,
                ),
                SizedBox(height: isDesktop ? 20 : 16),
                _buildDateField(
                  label: 'Fecha de Finalización',
                  icon: Icons.event_outlined,
                  selectedDate: _fechaFin,
                  onDateSelected: (date) => setState(() => _fechaFin = date),
                  isDesktop: isDesktop,
                  isOptional: true,
                ),
              ],
            ),

          SizedBox(height: isDesktop ? 20 : 16),

          // Dosis
          _buildDosisSection(isDesktop),

          SizedBox(height: isDesktop ? 20 : 16),

          // Motivo
          _buildDropdownField(
            label: 'Motivo del Tratamiento',
            icon: Icons.assignment_outlined,
            value: _motivoTratamiento,
            items: const [
              {'value': 'preventivo', 'label': 'Preventivo'},
              {'value': 'varroa', 'label': 'Infestación de Varroa'},
              {'value': 'nosema', 'label': 'Nosema'},
              {'value': 'otro', 'label': 'Otro'},
            ],
            onChanged: (value) => setState(() => _motivoTratamiento = value!),
            isDesktop: isDesktop,
          ),

          SizedBox(height: isDesktop ? 20 : 16),

          // Observaciones
          _buildTextAreaField(
            label: 'Observaciones',
            icon: Icons.notes_outlined,
            controller: _observacionesController,
            hint:
                'Ingrese cualquier observación relevante sobre el tratamiento...',
            isDesktop: isDesktop,
          ),

          SizedBox(height: isDesktop ? 20 : 16),

          // Recordatorio
          _buildCheckboxField(
            label: 'Crear recordatorio para finalización del tratamiento',
            value: _crearRecordatorio,
            onChanged: (value) => setState(() => _crearRecordatorio = value!),
            isDesktop: isDesktop,
          ),
        ],
      ),
    );
  }

  Widget _buildTipoTratamientoSection(bool isDesktop) {
    final tratamientos = [
      {
        'value': 'acido_oxalico',
        'label': 'Ácido Oxálico',
        'icon': Icons.science_outlined,
      },
      {
        'value': 'timol',
        'label': 'Timol',
        'icon': Icons.local_florist_outlined,
      },
      {
        'value': 'amitraz',
        'label': 'Amitraz',
        'icon': Icons.medication_outlined,
      },
      {'value': 'otro', 'label': 'Otro', 'icon': Icons.more_horiz_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: isDesktop ? 20 : 18,
              color: Colors.red[700],
            ),
            SizedBox(width: isDesktop ? 8 : 6),
            Text(
              'Tipo de Tratamiento',
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 12 : 8),
        if (isDesktop)
          Row(
            children:
                tratamientos.map((tratamiento) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildTratamientoOption(tratamiento, isDesktop),
                    ),
                  );
                }).toList(),
          )
        else
          Column(
            children:
                tratamientos.map((tratamiento) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildTratamientoOption(tratamiento, isDesktop),
                  );
                }).toList(),
          ),
      ],
    );
  }

  Widget _buildTratamientoOption(
    Map<String, dynamic> tratamiento,
    bool isDesktop,
  ) {
    final isSelected = _tipoTratamiento == tratamiento['value'];

    return InkWell(
      onTap: () => setState(() => _tipoTratamiento = tratamiento['value']),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.red[300]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: tratamiento['value'],
              groupValue: _tipoTratamiento,
              onChanged: (value) => setState(() => _tipoTratamiento = value!),
              activeColor: Colors.red[700],
            ),
            SizedBox(width: isDesktop ? 12 : 8),
            Icon(
              tratamiento['icon'],
              size: isDesktop ? 20 : 18,
              color: isSelected ? Colors.red[700] : Colors.grey[600],
            ),
            SizedBox(width: isDesktop ? 8 : 6),
            Expanded(
              child: Text(
                tratamiento['label'],
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.red[700] : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDosisSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.colorize_outlined,
              size: isDesktop ? 20 : 18,
              color: Colors.red[700],
            ),
            SizedBox(width: isDesktop ? 8 : 6),
            Text(
              'Dosis Aplicada',
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 8 : 6),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _dosisController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Cantidad',
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
                    borderSide: BorderSide(color: Colors.red[600]!),
                  ),
                  contentPadding: EdgeInsets.all(isDesktop ? 16 : 12),
                ),
                style: GoogleFonts.poppins(fontSize: isDesktop ? 16 : 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requerido';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: isDesktop ? 12 : 8),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _unidadDosis,
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
                    borderSide: BorderSide(color: Colors.red[600]!),
                  ),
                  contentPadding: EdgeInsets.all(isDesktop ? 16 : 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'ml', child: Text('ml')),
                  DropdownMenuItem(value: 'g', child: Text('g')),
                  DropdownMenuItem(value: 'tiras', child: Text('tiras')),
                ],
                onChanged: (value) => setState(() => _unidadDosis = value!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxField({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
    required bool isDesktop,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.red[700],
        ),
        SizedBox(width: isDesktop ? 8 : 4),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 14 : 12,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecomendacionesCard(bool isDesktop, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.red[700],
            size: isDesktop ? 24 : 20,
          ),
          SizedBox(width: isDesktop ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recomendaciones',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                SizedBox(height: isDesktop ? 8 : 4),
                Text(
                  'Para tratamientos con ácido oxálico, es recomendable aplicarlo cuando hay poca o ninguna cría en la colmena para maximizar su efectividad contra la varroa.',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 14 : 12,
                    color: Colors.red[700],
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
                  onPressed: _guardarTratamiento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
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
                    'Guardar Tratamiento',
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
                  onPressed: _guardarTratamiento,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Guardar Tratamiento',
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

  // Widgets auxiliares (reutilizando algunos del archivo anterior)
  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
    required bool isDesktop,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: isDesktop ? 20 : 18, color: Colors.red[700]),
            SizedBox(width: isDesktop ? 8 : 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (isOptional)
              Text(
                ' (Opcional)',
                style: GoogleFonts.poppins(
                  fontSize: isDesktop ? 14 : 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        SizedBox(height: isDesktop ? 8 : 6),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
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
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Seleccionar fecha',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktop ? 16 : 14,
                    color:
                        selectedDate != null
                            ? Colors.black87
                            : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
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
            Icon(icon, size: isDesktop ? 20 : 18, color: Colors.red[700]),
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
              borderSide: BorderSide(color: Colors.red[600]!),
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
            Icon(icon, size: isDesktop ? 20 : 18, color: Colors.red[700]),
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
              borderSide: BorderSide(color: Colors.red[600]!),
            ),
            contentPadding: EdgeInsets.all(isDesktop ? 16 : 12),
          ),
          style: GoogleFonts.poppins(fontSize: isDesktop ? 16 : 14),
        ),
      ],
    );
  }

  void _guardarTratamiento() {
    if (_formKey.currentState!.validate()) {
      // Aquí implementarías la lógica para guardar el tratamiento
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tratamiento registrado exitosamente',
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
              'Ayuda - Registro de Tratamiento',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Complete todos los campos para registrar el tratamiento sanitario. Seleccione el tipo de tratamiento, fechas, dosis y motivo. El sistema puede crear recordatorios automáticos.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Entendido',
                  style: GoogleFonts.poppins(color: Colors.red[600]),
                ),
              ),
            ],
          ),
    );
  }
}
