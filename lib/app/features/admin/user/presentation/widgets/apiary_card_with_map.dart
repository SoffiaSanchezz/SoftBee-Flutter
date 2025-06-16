// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class ApiaryCardWithMap extends StatelessWidget {
//   final Map<String, dynamic> apiary;
//   final int delay;

//   const ApiaryCardWithMap({required this.apiary, required this.delay, Key? key})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final LatLng coordinates = apiary['coordinates'];

//     return GestureDetector(
//       onTap: () => _showApiaryDetails(context),
//       child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(16),
//                   ),
//                   child: SizedBox(
//                     height: 120,
//                     width: double.infinity,
//                     child: GoogleMap(
//                       initialCameraPosition: CameraPosition(
//                         target: coordinates,
//                         zoom: 14,
//                       ),
//                       markers: {
//                         Marker(
//                           markerId: MarkerId(apiary['name']),
//                           position: coordinates,
//                           infoWindow: InfoWindow(title: apiary['name']),
//                         ),
//                       },
//                       zoomControlsEnabled: false,
//                       myLocationButtonEnabled: false,
//                       liteModeEnabled: true,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           apiary['name'],
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         Text(
//                           apiary['location'],
//                           style: GoogleFonts.poppins(color: Colors.black54),
//                         ),
//                         Text(
//                           'Última visita: ${apiary['lastVisit']}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//           .animate()
//           .fadeIn(duration: 800.ms, delay: delay.ms)
//           .moveY(begin: 20, end: 0),
//     );
//   }

//   void _showApiaryDetails(BuildContext context) {
//     // Puedes reutilizar tu modal existente aquí si lo deseas.
//   }
// }
