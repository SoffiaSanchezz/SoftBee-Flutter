// class Pregunta {
//   final String id;
//   final String texto;
//   final String tipoRespuesta;
//   final bool seleccionada;
//   final bool obligatoria;
//   final List<String>? opciones;
//   final int? min;
//   final int? max;
//   final String? dependeDe;
//   String? respuestaSeleccionada;

//   Pregunta({
//     required this.id,
//     required this.texto,
//     required this.seleccionada,
//     this.tipoRespuesta = "texto",
//     this.obligatoria = false,
//     this.opciones,
//     this.min,
//     this.max,
//     this.dependeDe,
//     this.respuestaSeleccionada,
//   });

//   factory Pregunta.fromJson(Map<String, dynamic> json) {
//     return Pregunta(
//       id: json['id'],
//       texto: json['pregunta'],
//       seleccionada: false,
//       tipoRespuesta: json['tipo'],
//       obligatoria: json['obligatoria'] ?? false,
//       opciones:
//           json['opciones'] != null ? List<String>.from(json['opciones']) : null,
//       min: json['min'],
//       max: json['max'],
//       dependeDe: json['depende_de'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'pregunta': texto,
//       'tipo': tipoRespuesta,
//       'obligatoria': obligatoria,
//       'opciones': opciones,
//       'min': min,
//       'max': max,
//       'depende_de': dependeDe,
//     };
//   }
// }

// class Apiario {
//   final int id;
//   final String nombre;
//   final String ubicacion;

//   Apiario({required this.id, required this.nombre, required this.ubicacion});

//   factory Apiario.fromJson(Map<String, dynamic> json) {
//     return Apiario(
//       id: json['id'],
//       nombre: json['nombre'],
//       ubicacion: json['ubicacion'],
//     );
//   }
// }

// class Colmena {
//   final int id;
//   final int numeroColmena;
//   final int idApiario;

//   Colmena({
//     required this.id,
//     required this.numeroColmena,
//     required this.idApiario,
//   });

//   factory Colmena.fromJson(Map<String, dynamic> json) {
//     return Colmena(
//       id: json['id'],
//       numeroColmena: json['numero_colmena'],
//       idApiario: json['id_apiario'],
//     );
//   }
// }
