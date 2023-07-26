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
      debugShowCheckedModeBanner: false,
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
  var isUsedSupport = false;
  var isUsedEnergy = false;
  var isUsedVSTAR = false;
  var isUsedGX = false;

  List<Map> cards = [
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
    {'damage': 0, 'ability': false},
  ];

  void allReset() {
    cards.asMap().forEach((index, _) {
      resetCardData(index);
     });
     isUsedSupport = false;
     isUsedEnergy = false;
     isUsedVSTAR= false;
     isUsedGX= false;

     selectedDamage = {'type': '+', 'damage': 10};
  }

  void turnEnd() {
    setState(() {
      cards.asMap().forEach((index, _) {
        cards[index]['ability'] = false;
      });
      isUsedSupport = false;
     isUsedEnergy = false;
    });
  }

  void selectDamage(int damage, String type) {
    setState(() {
      selectedDamage['damage'] = damage;
      selectedDamage['type'] = type;
    });
  }

  void changeSupportStatus() {
    setState(() {
      isUsedSupport = !isUsedSupport;
    });
  }

  void changeEnergyStatus() {
    setState(() {
      isUsedEnergy = !isUsedEnergy;
    });
  }

  void useVSTAR() {
    setState(() {
      isUsedVSTAR = true;
    });
  }

  void useGX() {
    setState(() {
      isUsedGX = true;
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
    final latestDamage = cards[index]['damage'] - selectedDamage['damage'];

    cards[index]['damage'] = latestDamage < 0 ? 0: latestDamage;
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
      // backgroundColor: Colors.lightBlue[200],
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
                    SettingCard(
                      cardText: 'ゲーム終了',
                      onPressed: () => allReset(),
                    ),
                    SettingCard(
                      cardText: 'ターン終了',
                      onPressed: () => turnEnd(),
                    ),
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
                  Row(
                    children: [
                      Column(
                        children: [
                          Power(
                            isUsedPower: isUsedVSTAR,
                            name: 'VSTAR',
                            imagePath: 'assets/images/vstar.png',
                            usePower: useVSTAR,
                          ),
                          Power(
                            isUsedPower: isUsedGX,
                            name: 'GX',
                            imagePath: 'assets/images/gx.png',
                            usePower: useGX,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          OneActionPerTurn(
                            isUsed: isUsedSupport,
                            actionName: 'サポート',
                            imagePath: 'assets/images/pokemon-trainer.png',
                            changeStatus: changeSupportStatus,
                          ),
                          OneActionPerTurn(
                            isUsed: isUsedEnergy,
                            actionName: '手貼り',
                            imagePath: 'assets/images/energy.png',
                            changeStatus: changeEnergyStatus,
                          ),
                        ],
                      ),
                    ],
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
  final Function() onPressed;

  const SettingCard({super.key, required this.cardText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
        child: Text(cardText)
      ),
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
          backgroundColor: damage == selectedDamage['damage'] && selectedDamage['type'] == type? Colors.yellow[400] :Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$type$damage", style: const TextStyle(color: Colors.black)),
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
          backgroundColor: damage == selectedDamage['damage'] && selectedDamage['type'] == type? Colors.yellow[400] :Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$type$damage", style: const TextStyle(color: Colors.black)),
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

    Widget pokeCard() {
      return SizedBox(
        width: SizeConfig.blockSizeHorizontal * 16,
        height: SizeConfig.blockSizeHorizontal * 16,
        child: Card(
          elevation: 5,
          color: Colors.blue[600],
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
                child: Text(card['damage'].toString(), style: const TextStyle(fontSize: 20.0),),
              ),
              AnimatedSwitcher(
                duration: const Duration(seconds: 0),
                child: card['ability']? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    changeAbility(index);
                  },
                  child: const Text('used', style: TextStyle(fontSize: 15.0)),
                ):
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    changeAbility(index);
                  },
                  child: const Text('unused', style: TextStyle(fontSize: 15.0)),
                ),
              ),
            ],
          )
        ),
      );
    }

    return LongPressDraggable(
      data: index,
      feedback: pokeCard(),
      child: DragTarget<int>(
        onAccept: (data) {
          onCardSwapped(data, index);
        },
        builder: (_,__,___) {
          return pokeCard();
        }
      ),
    );
  }
}

class OneActionPerTurn extends StatelessWidget {
  final bool isUsed;
  final String actionName;
  final String imagePath;
  final Function() changeStatus;

  const OneActionPerTurn({super.key, required this.isUsed, required this.actionName ,required this.imagePath,required this.changeStatus});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeStatus();
      },
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 0),
        child: isUsed? SizedBox(
          key: const ValueKey(true),
                width: SizeConfig.blockSizeHorizontal * 15,
                height: SizeConfig.blockSizeHorizontal * 8,
                child: Card(
                  elevation: 5,
                  color: Colors.red[600],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(imagePath),
                      ),
                      const Text('使用済', style: TextStyle(fontSize: 10.0, color: Colors.white),),
                    ],
                  )
                ),
              ): SizedBox(
                key: const ValueKey(false),
                width: SizeConfig.blockSizeHorizontal * 15,
                height: SizeConfig.blockSizeHorizontal * 8,
                child: Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(imagePath),
                      ),
                      Text(actionName, style: const TextStyle(fontSize: 10.0),),
                    ],
                  )
                )
              ),
      ),
    );
  }
}

class Power extends StatelessWidget {
  final bool isUsedPower;
  final String name;
  final String imagePath;
  final Function() usePower;

  const Power({super.key, required this.isUsedPower, required this.name, required this.imagePath, required this.usePower});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        usePower();
      },
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 0),
        child: isUsedPower? SizedBox(
          key: const ValueKey(true),
                width: SizeConfig.blockSizeHorizontal * 15,
                height: SizeConfig.blockSizeHorizontal * 8,
                child: Card(
                  elevation: 5,
                  color: Colors.red[600],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(imagePath),
                      ),
                      const Text('使用済', style: TextStyle(fontSize: 10.0, color: Colors.white),),
                    ],
                  )
                ),
              ): SizedBox(
                key: const ValueKey(false),
                width: SizeConfig.blockSizeHorizontal * 15,
                height: SizeConfig.blockSizeHorizontal * 8,
                child: Card(
                  elevation: 5,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(imagePath),
                      ),
                      Text(name, style: const TextStyle(fontSize: 10.0),),
                    ],
                  )
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
            width: SizeConfig.blockSizeHorizontal * 16,
            height: SizeConfig.blockSizeHorizontal * 16,
            child: Card(
              elevation: 5,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete),
                  Text('Trash', style: TextStyle(fontSize: 20.0),),
                ],
              )
            ),
          );
        }
      );
  }
}