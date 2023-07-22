import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 画面を横向きで固定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Map> cards = [
    {'damage': 10, 'ability': 'unused'},
    {'damage': 20, 'ability': 'unused'},
    {'damage': 30, 'ability': 'unused'},
    {'damage': 40, 'ability': 'unused'},
    {'damage': 50, 'ability': 'unused'},
    {'damage': 60, 'ability': 'unused'},
    {'damage': 70, 'ability': 'unused'},
    {'damage': 80, 'ability': 'unused'},
    {'damage': 90, 'ability': 'unused'},
  ];

  void swapCardData(draggedIndex, targetIndex) {
    setState(() {
      final targetData = cards[targetIndex];

      cards[targetIndex] = cards[draggedIndex];
      cards[draggedIndex] = targetData;
    });
  }

  void resetCardData(targetIndex) {
    setState(() {
      cards[targetIndex] = {'damage': 0, 'ability': 'unused'};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              DraggableCard(
                index: 0,
                card: cards[0],
                onCardSwapped: (draggedIndex, targetIndex) {
                  swapCardData(draggedIndex, targetIndex);
                }),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(int i = 1; i < cards.length; i++)
                      DraggableCard(
                        index: i,
                        card: cards[i],
                        onCardSwapped: (draggedIndex, targetIndex) {
                          swapCardData(draggedIndex, targetIndex);
                        }
                      ),
                    Trash(
                      resetCardData: ((targetIndex) => resetCardData(targetIndex))
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableCard extends StatelessWidget {
  final int index;
  final Map card;
  final Function(int draggedIndex, int targetIndex) onCardSwapped;

  const DraggableCard({super.key, required this.index, required this.card, required this.onCardSwapped});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: index,
      feedback: const Card(
        color: Colors.blue,
        child: Text('moving')
      ),
      child: DragTarget<int>(
        onAccept: (data) {
          onCardSwapped(data, index);
        },
        builder: (_,__,___) {
          return Card(
            color: Colors.red,
            child: Column(
              children: [
                Text(card['damage'].toString()),
                Text(card['ability']),
              ],
            )
          );
        }
      ),
    );
  }
}

class Trash extends StatelessWidget {
  final Function(int targetIndex) resetCardData;

  const Trash({super.key, required this.resetCardData});

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
        onAccept: (data) {
          resetCardData(data);
        },
        builder: (_,__,___) {
          return const Card(
            color: Colors.grey,
            child: Text('Trash')
          );
        }
      );
  }
}