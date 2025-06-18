// class Colmena {
//   final int id;
//   final int numeroColmena;
//   final int idApiario;
//   final DateTime fechaRegistro;

//   Colmena({
//     required this.id,
//     required this.numeroColmena,
//     required this.idApiario,
//     DateTime? fechaRegistro,
//   }) : fechaRegistro = fechaRegistro ?? DateTime.now();

//   factory Colmena.fromJson(Map<String, dynamic> json) {
//     return Colmena(
//       id: json['id'],
//       numeroColmena: json['numero_colmena'],
//       idApiario: json['id_apiario'],
//       fechaRegistro:
//           json['fecha_registro'] != null
//               ? DateTime.parse(json['fecha_registro'])
//               : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'numero_colmena': numeroColmena,
//       'id_apiario': idApiario,
//       'fecha_registro': fechaRegistro.toIso8601String(),
//     };
//   }

//   @override
//   String toString() {
//     return 'Colmena{id: $id, numero: $numeroColmena, apiario: $idApiario}';
//   }

//   Colmena copyWith({
//     int? id,
//     int? numeroColmena,
//     int? idApiario,
//     DateTime? fechaRegistro,
//   }) {
//     return Colmena(
//       id: id ?? this.id,
//       numeroColmena: numeroColmena ?? this.numeroColmena,
//       idApiario: idApiario ?? this.idApiario,
//       fechaRegistro: fechaRegistro ?? this.fechaRegistro,
//     );
//   }
// }
