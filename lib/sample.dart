// class filter_page extends StatelessWidget {
//   const filter_page({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: Column(
//         children: [
//           Center(
//             child: Text(
//               'Filter',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//           ),
//           SizedBox(height: 20),
//           // By distance
//           Column(
//             children: [
//               Container(
//                 width: double.maxFinite,
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'By distance',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 12),
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(vertical: 5),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('500M'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('1KM'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('2KM'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('5KM'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               // By Connection Type
//               Container(
//                 width: double.maxFinite,
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Connection type',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 12),
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(vertical: 5),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('CCS'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('CCS2'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('Type2'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('Chademo'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               //By vehicle type
//               Container(
//                 width: double.maxFinite,
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Vehicle type',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 12),
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(vertical: 5),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('2 wheeler'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('3 wheeler'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Container(
//                             height: 40,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 style: BorderStyle.solid,
//                                 width: 2,
//                               ),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: TextButton(
//                               onPressed: null,
//                               child: Text('4 wheeler'),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 60,
//               ),
//               Container(
//                 height: 40,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: Colors.blue, borderRadius: BorderRadius.circular(5)),
//                 child: TextButton(
//                     onPressed: null,
//                     child: Text(
//                       'Submit',
//                       style: TextStyle(color: Colors.white),
//                     )),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }