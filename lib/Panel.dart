import 'package:flutter/material.dart';


class Panel extends StatelessWidget {
  final bool isListening;
  final Function() onStartListening;
  final Function() onStopListening;

  Panel({required this.isListening, required this.onStartListening, required this.onStopListening});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        ElevatedButton(
          onPressed: isListening ? onStopListening : onStartListening,
          child: SizedBox.fromSize(
            size: Size.fromRadius(50),
            child: FittedBox(
              child: Icon(isListening ? Icons.mic_off : Icons.mic),
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),



        SizedBox(height: MediaQuery.of(context).size.height * 0.1),



    Center(

    child: Container(
      width: MediaQuery.of(context).size.width * 0.5,
    child:
    Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    Stack(
    children: [
    Image.asset('assets/cloud.png'), // Szövegfelhő képe
    Positioned(
    top: 40, // A szöveg elhelyezésének pozíciója a képen
    left: 20,
    child: Container(
    padding: EdgeInsets.all(8),
    color: Colors.white,
    child: Text(
    'Ez egy szöveg a felhőben',
    style: TextStyle(fontSize: 14),
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ),







/*
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.white70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: Text('for cycle'),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: Text('switch case'),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: Text('switch case'),
              ),
            ],
          ),
        ),

        */


      ],
    );
  }
}
