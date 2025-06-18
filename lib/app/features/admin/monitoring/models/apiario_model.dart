// class Apiario {
//   final int id;
//   final String nombre;
//   final String ubicacion;
//   final DateTime fechaCreacion;

//   Apiario({
//     required this.id,
//     required this.nombre,
//     required this.ubicacion,
//     DateTime? fechaCreacion,
//   }) : fechaCreacion = fechaCreacion ?? DateTime.now();

//   factory Apiario.fromJson(Map<String, dynamic> json) {
//     return Apiario(
//       id: json['id'],
//       nombre: json['nombre'],
//       ubicacion: json['ubicacion'],
//       fechaCreacion:
//           json['fecha_creacion'] != null
//               ? DateTime.parse(json['fecha_creacion'])
//               : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'nombre': nombre,
//       'ubicacion': ubicacion,
//       'fecha_creacion': fechaCreacion.toIso8601String(),
//     };
//   }

//   @override
//   String toString() {
//     return 'Apiario{id: $id, nombre: $nombre, ubicacion: $ubicacion}';
//   }

//   Apiario copyWith({
//     int? id,
//     String? nombre,
//     String? ubicacion,
//     DateTime? fechaCreacion,
//   }) {
//     return Apiario(
//       id: id ?? this.id,
//       nombre: nombre ?? this.nombre,
//       ubicacion: ubicacion ?? this.ubicacion,
//       fechaCreacion: fechaCreacion ?? this.fechaCreacion,
//     );
//   }
// }
