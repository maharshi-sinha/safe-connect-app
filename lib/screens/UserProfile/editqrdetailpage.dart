// import 'package:flutter/material.dart';

// class EditQRDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> details;

//   EditQRDetailsPage({required this.details});

//   @override
//   _EditQRDetailsPageState createState() => _EditQRDetailsPageState();
// }

// class _EditQRDetailsPageState extends State<EditQRDetailsPage> {
//   late TextEditingController nameController;
//   late TextEditingController emailController;
//   late TextEditingController contactNumberController;
//   late TextEditingController emergencyContactController;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.details['name'].toString());
//     emailController = TextEditingController(text: widget.details['email'].toString());
//     contactNumberController = TextEditingController(text: widget.details['contactNumber'].toString());
//     emergencyContactController = TextEditingController(text: widget.details['emergencyContact'].toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit QR Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: contactNumberController,
//               decoration: InputDecoration(labelText: 'Contact Number'),
//             ),
//             TextField(
//               controller: emergencyContactController,
//               decoration: InputDecoration(labelText: 'Emergency Contact'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 print('Updated Name: ${nameController.text}');
//                 print('Updated Email: ${emailController.text}');
//                 print('Updated Contact Number: ${contactNumberController.text}');
//                 print('Updated Emergency Contact: ${emergencyContactController.text}');
//                 Navigator.pop(context); 
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     contactNumberController.dispose();
//     emergencyContactController.dispose();
//     super.dispose();
//   }
// }