import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizu/const/colors.dart';
import 'package:quizu/const/images.dart';
import 'package:quizu/const/text_style.dart';
import 'package:quizu/repository/api_services.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var currentQuestionIndex = 0;
  // int seconds = 60;

  Duration myDuration = const Duration(minutes: 2);

  Timer? timer;
  late Future quiz;

  int points = 0;

  var isLoaded = false;

  var optionsList = [];

  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    quiz = getQuiz1();
    // startTimer();
    startTimer1();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  resetColors() {
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  gotoNextQuestion() {
    setState(() {
      isLoaded = false;
      currentQuestionIndex++;
      resetColors();
      seconds = 120;
      myDuration = const Duration(minutes: 2);
      timer!.cancel();
      startTimer1();
    });
  }

  void startTimer1() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => {setCountDown()});
  }

  int seconds = 120;
  void setCountDown() {
    const reduceSecondsBy = 1;

    seconds = myDuration.inSeconds - reduceSecondsBy;
    setState(() {
      if (seconds < 0) {
        seconds--;
      } else if (seconds == 0) {
        if (currentQuestionIndex != 29) {
          gotoNextQuestion();
        }
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  bool _isLoading = false;

  ssndResult(score) async {
    setState(() {
      _isLoading = true;
    });

    await updatescore(context, score);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final second = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [purple, deepPurple],
                )),
                child: FutureBuilder(
                  future: quiz,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;

                      if (isLoaded == false) {
                        List it = [
                          'a: ${data[currentQuestionIndex]['a']} ',
                          "b: ${data[currentQuestionIndex]['b']}",
                          "c: ${data[currentQuestionIndex]['c']}",
                          "d: ${data[currentQuestionIndex]['d']}"
                        ];
                        optionsList = it;
                        optionsList.shuffle();
                        isLoaded = true;
                      }
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: lightgrey, width: 2),
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.xmark,
                                          color: Colors.white,
                                          size: 28,
                                        )),
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      normalText(
                                          color: seconds <= 30
                                              ? Colors.red
                                              : Colors.green,
                                          size: 24,
                                          text: "$minutes:$second"),
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CircularProgressIndicator(
                                          value: seconds / 120,
                                          valueColor: AlwaysStoppedAnimation(
                                              seconds <= 30
                                                  ? Colors.red
                                                  : Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Image.asset(ideas, width: 200, height: 150),
                              const SizedBox(height: 20),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: normalText(
                                      color: lightgrey,
                                      size: 18,
                                      text:
                                          "Question ${currentQuestionIndex + 1} of ${data.length}")),
                              const SizedBox(height: 20),
                              normalText(
                                  color: Colors.white,
                                  size: 20,
                                  text: data[currentQuestionIndex]['Question']),
                              const SizedBox(height: 20),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: optionsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var answer =
                                      data[currentQuestionIndex]['correct'];

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (answer.toString() ==
                                            optionsList[index].toString()[0]) {
                                          optionsColor[index] = Colors.green;
                                          points = points + 1;
                                        } else {
                                          optionsColor[index] = Colors.red;
                                        }

                                        if (currentQuestionIndex <
                                            data.length - 1) {
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            gotoNextQuestion();
                                          });
                                        } else {
                                          timer!.cancel();
                                          //here you can do whatever you want with the results
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      width: size.width - 100,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: optionsColor[index],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: headingText(
                                        color: purple,
                                        size: 18,
                                        text: optionsList[index].toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : currentQuestionIndex == 29
                                      ? ElevatedButton(
                                          onPressed: () {
                                            ssndResult(points);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.deepOrange,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0)),
                                              minimumSize:
                                                  Size(size.width / 0.2, 50)),
                                          child: const Text(
                                            'show Result',
                                            style: TextStyle(
                                              fontFamily: "quick_bold",
                                              fontSize: 18,
                                              color: Colors.grey,
                                            ),
                                          ))
                                      : TextButton(
                                          onPressed: () {
                                            gotoNextQuestion();
                                          },
                                          child: const Text(
                                            'Skip',
                                            style: TextStyle(
                                              fontFamily: "quick_bold",
                                              fontSize: 18,
                                              color: Colors.grey,
                                            ),
                                          )),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    }
                  },
                ))));
  }
}
