// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: DraggableCardDemo(),
//     );
//   }
// }

// class DraggableCardDemo extends StatefulWidget {
//   const DraggableCardDemo({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _DraggableCardDemoState createState() => _DraggableCardDemoState();
// }

// class _DraggableCardDemoState extends State<DraggableCardDemo> {
//   List<String> cardList = ['Card 1', 'Card 2'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Swappable Cards')),
//       body: Center(
//         child: Stack(
//           children: cardList
//               .asMap()
//               .map((index, cardText) {
//                 return MapEntry(
//                   index,
//                   DraggableCard(
//                     cardText: cardText,
//                     index: index,
//                     cardList: cardList,
//                     onCardSwapped: (draggedIndex, targetIndex) {
//                       setState(() {
//                         // Swap the cards in the list
//                         String draggedCard = cardList[draggedIndex];
//                         cardList[draggedIndex] = cardList[targetIndex];
//                         cardList[targetIndex] = draggedCard;
//                       });
//                     },
//                   ),
//                 );
//               })
//               .values
//               .toList(),
//         ),
//       ),
//     );
//   }
// }

// class DraggableCard extends StatelessWidget {
//   final String cardText;
//   final int index;
//   final List<String> cardList;
//   final Function(int draggedIndex, int targetIndex) onCardSwapped;

//   const DraggableCard({super.key,
//     required this.cardText,
//     required this.index,
//     required this.cardList,
//     required this.onCardSwapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: index * 80.0, // Adjust the vertical position of each card
//       child: Draggable(
//         feedback: Material(
//           child: Card(
//             color: Colors.blue, // You can use different colors for each card.
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 cardText,
//                 style: const TextStyle(fontSize: 20.0, color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//         childWhenDragging: Container(),
//         onDragCompleted: () {
//           // Handle if the drag is completed (optional).
//         },
//         onDraggableCanceled: (_, __) {
//           // Handle if the drag is canceled (optional).
//         },
//         data: cardText,
//         child: DragTarget<String>(
//           onWillAccept: (data) => data != cardText,
//           onAccept: (data) {
//             int draggedIndex = cardList.indexOf(data);
//             int targetIndex = cardList.indexOf(cardText);
//             onCardSwapped(draggedIndex, targetIndex);
//           },
//           builder: (_, __, ___) {
//             return Card(
//               color: Colors.blue, // You can use different colors for each card.
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   cardText,
//                   style: const TextStyle(fontSize: 20.0, color: Colors.white),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
