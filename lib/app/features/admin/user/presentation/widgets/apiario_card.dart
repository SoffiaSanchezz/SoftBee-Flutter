// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:soft_bee/core/entities/user.dart';

// class ApiarioCard extends StatefulWidget {
//   final Apiario apiario;

//   const ApiarioCard({super.key, required this.apiario});

//   @override
//   State<ApiarioCard> createState() => _ApiarioCardState();
// }

// class _ApiarioCardState extends State<ApiarioCard> {
//   LatLng? apiarioLocation;

//   @override
//   void initState() {
//     super.initState();
//     _loadLocation();
//   }

//   Future<void> _loadLocation() async {
//     // Verificamos si la dirección no está vacía
//     if (widget.apiario.direccion.isNotEmpty) {
//       try {
//         // Obtenemos las coordenadas de la dirección
//         List<Location> locations = await locationFromAddress(
//           widget.apiario.direccion,
//         );
//         if (locations.isNotEmpty) {
//           setState(() {
//             apiarioLocation = LatLng(
//               locations.first.latitude,
//               locations.first.longitude,
//             );
//           });
//         } else {
//           // No se encontraron coordenadas para la dirección
//           setState(() {
//             apiarioLocation = null;
//           });
//         }
//       } catch (e) {
//         // Error al obtener coordenadas
//         setState(() {
//           apiarioLocation = null;
//         });
//       }
//     } else {
//       // Dirección vacía
//       setState(() {
//         apiarioLocation = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           ListTile(
//             title: Text(widget.apiario.direccion),
//             subtitle: Text('Colmenas: ${widget.apiario.cantidadColmenas}'),
//           ),
//           if (apiarioLocation != null)
//             SizedBox(
//               height: 200,
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: apiarioLocation!,
//                   zoom: 15,
//                 ),
//                 markers: {
//                   Marker(
//                     markerId: MarkerId(widget.apiario.id.toString()),
//                     position: apiarioLocation!,
//                   ),
//                 },
//               ),
//             )
//           else
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('Dirección inválida o no encontrada'),
//             ),
//         ],
//       ),
//     );
//   }
// }
