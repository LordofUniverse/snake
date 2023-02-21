import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool start = false;
  List<int> snakePosition = [];
  int food = 0;
  String dir = "up";
  bool add = false;
  bool end = false;

  void startGame(BuildContext context) {
    int no_of_rows = MediaQuery.of(context).size.width ~/ 20;

    Random random = Random();

    snakePosition = [
      random.nextInt(MediaQuery.of(context).size.height *
              0.8 ~/
              20 *
              MediaQuery.of(context).size.width ~/
              20 -
          4 * no_of_rows)
    ];
    for (var i = 1; i < 3; i++) {
      snakePosition.add(snakePosition[i - 1] + no_of_rows);
    }

    generateFood();
    const duration = Duration(milliseconds: 300);

    Timer.periodic(duration, (Timer timer) {
      if (end) {
        timer.cancel();
        end = false;
        dir = "up";
        return;
      }
      updateGame(context);
    });
  }

  void generateFood() {
    Random random = Random();
    while (true) {
      food = random.nextInt(MediaQuery.of(context).size.height *
          0.8 ~/
          20 *
          MediaQuery.of(context).size.width ~/
          20);
      if (snakePosition.contains(food)) {
        continue;
      } else {
        break;
      }
    }
  }

  void updateGame(BuildContext context) {
    int no_of_rows = MediaQuery.of(context).size.width ~/ 20;

    if (add) {
      snakePosition[1] = snakePosition[0];
      add = false;
    } else {
      for (var i = snakePosition.length - 1; i > 0; i--) {
        snakePosition[i] = snakePosition[i - 1];
      }
    }

    setState(() {
      switch (dir) {
        case 'down':
          if (snakePosition[0] >
              MediaQuery.of(context).size.height *
                      0.8 ~/
                      20 *
                      MediaQuery.of(context).size.width ~/
                      20 -
                  no_of_rows) {
            snakePosition[0] -= MediaQuery.of(context).size.height *
                0.8 ~/
                20 *
                MediaQuery.of(context).size.width ~/
                20;
          } else {
            snakePosition[0] = snakePosition[0] + no_of_rows;
          }

          break;
        case 'up':
          if (snakePosition[0] < no_of_rows) {
            snakePosition[0] += MediaQuery.of(context).size.height *
                    0.8 ~/
                    20 *
                    MediaQuery.of(context).size.width ~/
                    20 -
                no_of_rows;
          } else {
            snakePosition[0] = snakePosition[0] - no_of_rows;
          }
          break;

        case 'right':
          if ((snakePosition[0] + 1) % (no_of_rows) == 0) {
            snakePosition[0] -= no_of_rows - 1;
          } else {
            snakePosition[0] += 1;
          }
          break;

        case 'left':
          if (snakePosition[0] % no_of_rows == 0) {
            snakePosition[0] += no_of_rows - 1;
          } else {
            snakePosition[0] -= 1;
          }
          break;
      }

      if (snakePosition.sublist(1).contains(snakePosition[0])) {
        end = true;
        start = false;
      } else {
        if (snakePosition[0] == food) {
          generateFood();
          add = true;
          snakePosition.insert(1, snakePosition[1]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!start) {
      startGame(context);
      start = true;
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (dir != 'up' && details.delta.dy > 0) {
                  dir = 'down';
                } else if (dir != 'down' && details.delta.dy < 0) {
                  dir = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (dir != 'left' && details.delta.dx > 0) {
                  dir = 'right';
                } else if (dir != 'right' && details.delta.dx < 0) {
                  dir = 'left';
                }
              },
              child: Container(
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.blueAccent)),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    // itemCount: MediaQuery.of(context).size.width ~/ 5,
                    itemCount: MediaQuery.of(context).size.height *
                        0.8 ~/
                        20 *
                        MediaQuery.of(context).size.width ~/
                        20,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else if (index == food) {
                        return Container(
                          padding: const EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Color.fromRGBO(18, 18, 18, 1),
                            ),
                          ),
                        );
                      }
                    },
                  )),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
