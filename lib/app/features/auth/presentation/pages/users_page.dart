// // lib/app/features/auth/presentation/pages/users_page.dart

// import 'package:flutter/material.dart';
// import 'package:soft_bee/app/features/auth/data/datasources/user_remote_data_source.dart';


// class UsersPage extends StatefulWidget {
//   @override
//   _UsersPageState createState() => _UsersPageState();
// }

// class _UsersPageState extends State<UsersPage> {
//   final dataSource = UserRemoteDataSource();
//   late Future<List<Map<String, dynamic>>> users;

//   @override
//   void initState() {
//     super.initState();
//     users = dataSource.fetchUsers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Usuarios')),
//       body: FutureBuilder(
//         future: users,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return Center(child: CircularProgressIndicator());

//           if (snapshot.hasError)
//             return Center(child: Text("Error: ${snapshot.error}"));

//           final data = snapshot.data!;
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder:
//                 (_, i) => ListTile(
//                   title: Text(data[i]['name']),
//                   subtitle: Text("ID: ${data[i]['id']}"),
//                 ),
//           );
//         },
//       ),
//     );
//   }
// }
