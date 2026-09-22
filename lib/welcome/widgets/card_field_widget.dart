// import 'package:flutter/material.dart';
// import 'package:notizen/models/home_model.dart';

// class CardFieldWidget extends StatelessWidget {
//   const CardFieldWidget({super.key, required this.item});

//   final HomeModel item;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(11),
//         side: BorderSide(color: Colors.white, width: 1),
//       ),
//       color: Colors.transparent,
//       elevation: 0,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Padding(
//           padding: EdgeInsets.symmetric(vertical: 15),
//           child: Text(
//             item.title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontFamily: "Poppins",
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
