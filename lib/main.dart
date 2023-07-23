import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/size_config.dart';

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
  var selectedDamage = {'type': '+', 'damage': 10};
  List<Map> cards = [
    {'damage': 10, 'ability': false},
    {'damage': 20, 'ability': false},
    {'damage': 30, 'ability': false},
    {'damage': 40, 'ability': false},
    {'damage': 50, 'ability': false},
    {'damage': 60, 'ability': false},
    {'damage': 70, 'ability': false},
    {'damage': 80, 'ability': false},
    {'damage': 90, 'ability': false},
  ];

  void selectDamage(int damage, String type) {
    setState(() {
      selectedDamage['damage'] = damage;
      selectedDamage['type'] = type;
    });
  }

  void swapCardData(draggedIndex, targetIndex) {
    setState(() {
      final targetData = cards[targetIndex];

      cards[targetIndex] = cards[draggedIndex];
      cards[draggedIndex] = targetData;
    });
  }

  void resetCardData(targetIndex) {
    setState(() {
      cards[targetIndex] = {'damage': 0, 'ability': false};
    });
  }

  void changeDamage(index) {
    setState(() {
      selectedDamage['type'] == '+'? damageUp(index): damageDown(index);
    });
  }

  void damageUp(index) {
    cards[index]['damage'] += selectedDamage['damage'];
  }

  void damageDown(index) {
    cards[index]['damage'] -= selectedDamage['damage'];
  }

  void changeAbility(index) {
    setState(() {
      cards[index]['ability'] = !cards[index]['ability'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    SizeConfig().init(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SettingCard(cardText: 'ゲーム終了'),
                    const SettingCard(cardText: 'ターン終了'),
                    DamageUpCard(
                      damage: 10,
                      selectedDamage: selectedDamage,
                      onPressed: (damage, type) => selectDamage(damage, type),
                    ),
                    DamageUpCard(
                      damage: 50,
                      selectedDamage: selectedDamage,
                      onPressed: (damage, type) => selectDamage(damage, type),
                    ),
                    DamageUpCard(
                      damage: 100,
                      selectedDamage: selectedDamage,
                      onPressed: (damage, type) => selectDamage(damage, type),
                    ),
                    DamageDownCard(
                      damage: 10,
                      selectedDamage: selectedDamage,
                      onPressed: (damage, type) => selectDamage(damage, type),
                    ),
                    DamageDownCard(
                      damage: 50,
                      selectedDamage: selectedDamage,
                      onPressed: (damage, type) => selectDamage(damage, type),
                    ),
                    DamageDownCard(
                      damage: 100,
                      selectedDamage: selectedDamage,
                      onPressed: (damage, type) => selectDamage(damage, type),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Support(
                    resetCardData: ((targetIndex) => resetCardData(targetIndex))
                  ),
                  DraggableCard(
                    index: 0,
                    card: cards[0],
                    onCardSwapped: (draggedIndex, targetIndex) {
                      swapCardData(draggedIndex, targetIndex);
                    },
                    changeDamage: (index) => changeDamage(index),
                    changeAbility: (index) => changeAbility(index),
                  ),
                  Trash(
                    resetCardData: ((targetIndex) => resetCardData(targetIndex))
                  ),
                ],
              ),
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
                        },
                        changeDamage: (index) => changeDamage(index),
                        changeAbility: (index) => changeAbility(index),
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

class SettingCard extends StatelessWidget {
  final String cardText;
  const SettingCard({super.key, required this.cardText});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(cardText),
      )
    );
  }
}

class DamageUpCard extends StatelessWidget {
  final int damage;
  final Map<String, dynamic> selectedDamage;
  final Function(int damage, String type) onPressed;

  const DamageUpCard({super.key, required this.damage, required this.selectedDamage,required this.onPressed});

  @override
  Widget build(BuildContext context) {
     const type = '+';

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed(damage, type);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: damage == selectedDamage['damage'] && selectedDamage['type'] == type? Colors.blue :Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$type$damage"),
        )
      ),
    );
  }
}

class DamageDownCard extends StatelessWidget {
  final int damage;
  final Map<String, dynamic> selectedDamage;
  final Function(int damage, String type) onPressed;

  const DamageDownCard({super.key, required this.damage, required this.selectedDamage,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const type = '-';

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed(damage, type);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: damage == selectedDamage['damage'] && selectedDamage['type'] == type? Colors.blue :Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$type$damage"),
        )
      ),
    );
  }
}

class DraggableCard extends StatelessWidget {
  final int index;
  final Map card;
  final Function(int draggedIndex, int targetIndex) onCardSwapped;
  final Function(int index) changeDamage;
  final Function(int index) changeAbility;

  const DraggableCard({super.key, required this.index, required this.card, required this.onCardSwapped, required this.changeDamage, required this.changeAbility});

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    SizeConfig().init(context);

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
          return SizedBox(
            width: SizeConfig.blockSizeHorizontal * 20,
            height: SizeConfig.blockSizeHorizontal * 20,
            child: Card(
              color: Colors.red,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black
                    ),
                    onPressed: () {
                      changeDamage(index);
                    },
                    child: Text(card['damage'].toString()),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 0),
                    child: card['ability']? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        changeAbility(index);
                      },
                      child: const Text('used'),
                    ):
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent[100],
                        foregroundColor: Colors.black
                      ),
                      onPressed: () {
                        changeAbility(index);
                      },
                      child: const Text('unused'),
                    ),
                  ),
                ],
              )
            ),
          );
        }
      ),
    );
  }
}

class Support extends StatefulWidget {
  final Function(int targetIndex) resetCardData;

  const Support({super.key, required this.resetCardData});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  bool _isUsed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isUsed = !_isUsed;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 0),
        child: _isUsed? SizedBox(
          key: const ValueKey(true),
                width: SizeConfig.blockSizeHorizontal * 20,
                height: SizeConfig.blockSizeHorizontal * 20,
                child: const Card(
                  color: Colors.grey,
                  child: Center(child: Text('済み', style: TextStyle(fontSize: 20.0),))
                ),
              ): SizedBox(
                key: const ValueKey(false),
                width: SizeConfig.blockSizeHorizontal * 20,
                height: SizeConfig.blockSizeHorizontal * 20,
                child: const Card(
                  color: Colors.white,
                  child: Center(child: Text('サポート', style: TextStyle(fontSize: 20.0),))
                )
              ),
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
          return SizedBox(
            width: SizeConfig.blockSizeHorizontal * 20,
            height: SizeConfig.blockSizeHorizontal * 20,
            child: const Card(
              color: Colors.grey,
              child: Center(child: Text('Trash', style: TextStyle(fontSize: 20.0),))
            ),
          );
        }
      );
  }
}