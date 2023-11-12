import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'Panel.dart';
import 'VideoWidget.dart'; // Az új fájl importálása

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget { // Állapotot kezelő widget
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  late bool toggle = true;

  int szamlalo=0;

  // Speech2Text related:
  bool _isListening = false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late String _selectedLocaleId = 'en';
  String _currentWords = '';

  // Text2Speech related:
  TtsState ttsState = TtsState.stopped;
  FlutterTts  flutterTts= FlutterTts();
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.8;
  String? _newVoiceText;
  int valaszolas_fut = 0;
  String kerdes = '';
  int _selectedIndex = 0;
  String valasz = "";


  initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _controller = _controller = VideoPlayerController.asset('videos/video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });



    initTts();
    _initSpeech();

    valasz = "Én vagyok Dr. Mimi. Az interaktít eladói asszisztens.";
    print(valasz);
    setState(() =>
    _newVoiceText = valasz);
    valaszolas_fut = 0;


    _startVideo();
  }


  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      print("elerheto");
    } else {
      print("nem jo valamiert");
    }
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void stoppolok(){
    _stopListening();
    //myController.text = _lastWords;
    print(_lastWords);
  }



  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future<void> setLanguage() async {
    await flutterTts.setLanguage(_selectedLocaleId);
  }


  Future _speak() async {
    if(szamlalo==3){
      print("most tortenik");
      _selectedLocaleId = "de_AT";
      setLanguage();
    }
    if(szamlalo==4){
      _selectedLocaleId = "en";
      setLanguage();
    }

    szamlalo = szamlalo + 1;
    print(szamlalo);

    setLanguage();
    //await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }


  void _startVideo() async {
    setState(() {
      this.toggle = true;
      _controller.setVolume(0.0);
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });
  }


  void _newConnect() async {
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.8.147:8089'),
    );

    setState(() {
      this.toggle = true;
      _controller.setVolume(0.0);
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    /*
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _selectedLocaleId
    );
    setState(() {
      _isListening = true;
    });
     */
    //valasz = szoveg;//"What do you order?";
    //print(valasz);
    //setState(() =>
    //_newVoiceText = valasz);
    _speak();
    valaszolas_fut = 0;

  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() async {
      _lastWords = result.recognizedWords;
      //myController.text = _lastWords;
      //result_array = _lastWords.split(" ");

    });
  }

  WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.8.147:8089'),
  );

  /*

  final WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.8.128:8089'),
    );

  void _sendMessage() {
    channel.sink.add('Ez egy üzenet a kliensnek!');
  }
   */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Dr. Mimi'),
      ),
      body: Stack(
        children: [

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                child: SizedBox.fromSize(
                    size: Size.fromRadius(240),
                    child: FittedBox(
                        child:Image.asset('assets/image.png'), //
                ),// Szöveg
                ),// felhő képe,,
              ),
            ],
          ),



          /*
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/image.png'), // Szövegfelhő képe,,
              ),
            ],
          ),
           */


          Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.1,
                height: MediaQuery.of(context).size.height*0.05,
                child: Image.asset('assets/osztrak.png'),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.1,
                height: MediaQuery.of(context).size.height*0.05,
                child: Image.asset('assets/brazil.png'),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.1,
                height: MediaQuery.of(context).size.height*0.05,
                child: Image.asset('assets/flag_eng.png'),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.1,
                height: MediaQuery.of(context).size.height*0.05,
                child: Image.asset('assets/flag_hun.png'),
              )
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height*0.005,),

          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white30, Colors.black], // Világos színtől sötét színig
                  ),
                ),
                //height: 600,
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.33,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
                  onPressed: () {
                    setState(() {
                      print("play");
                      /*
                            Fluttertoast.showToast(
                                msg: "Még nem implementáltuk!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                             */

                    });
                  },
                  child:
                  Column( children: <Widget>[
                    Icon(
                      Icons.person,
                    ),
                    Text("Patient"),
                  ]
                  ),
                ),
              ),
              //SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white30, Colors.black], // Világos színtől sötét színig
                  ),
                ),
                //height: 600,
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.33,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
                  onPressed: () {
                    setState(() {
                      print("Mode");
                      /*
                            Fluttertoast.showToast(
                                msg: "Még nem implementáltuk!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                             */
                    });
                  },
                  child:
                  Column( children: <Widget>[
                    Icon(
                      Icons.person,
                    ),
                    Text("Mode"),
                  ]
                  ),
                ),
              ),
              //SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white30, Colors.black], // Világos színtől sötét színig
                  ),
                ),
                //height: 600,
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.33,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
                  onPressed: () {
                    setState(() {
                      print("play");
                      /*
                            Fluttertoast.showToast(
                                msg: "Még nem implementáltuk!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                             */
                    });
                  },
                  child:
                  Column( children: <Widget>[
                    Icon(
                      Icons.person,
                    ),
                    Text("Setting"),
                  ]
                  ),
                ),
              ),
            ],
          ),


          Center(
            child: ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Üzenet küldése a kliensnek'),
            ),
          ),
          */




        /*
        Panel(
            isListening: _isListening,
            onStartListening: _startListening,
            onStopListening: _stopListening,
          ),
         */

          //SizedBox(height: MediaQuery.of(context).size.height * 0.2),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VideoWidget(controller: _controller, toggle: toggle),

                  SizedBox(width: MediaQuery.of(context).size.width*0.35),

                  /*
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.05),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Image.asset('assets/image.png'), // Szövegfelhő képe,,
                      ),
                    ],
                  ),
                   */




                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Container(
                      //alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child:
                      Stack(
                      children: [
                        Image.asset('assets/cloud.png'), // Szövegfelhő képe
                        Positioned(
                        top: 40, // A szöveg elhelyezésének pozíciója a képen
                        left: 25,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.white,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: channel.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {

                                    // Az új üzenet elmentése a változóba
                                    _newVoiceText = snapshot.data;
                                    //valasz = "Én vagyok Dr. Mimi. Az interaktít eladói asszisztens.";
                                    //print(valasz);
                                    //setState(() => _newVoiceText = valasz);
                                    if(_newVoiceText!=valasz){
                                      _speak();
                                      //valaszolas_fut = 0;
                                      valasz=_newVoiceText!;
                                    }



                                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                                      setState(() {
                                        if(szamlalo==4){
                                          print("most tortenik");
                                          _selectedLocaleId = "de";
                                          setLanguage();
                                        }
                                      });
                                    });


                                    // setState hívása az új üzenet megjelenítéséhez
                                    /*
                                WidgetsBinding.instance!.addPostFrameCallback((_) {
                                  setState(() {});
                                });

                                channel = WebSocketChannel.connect(
                                  Uri.parse('ws://192.168.8.147:8089'),
                                );
                                 */

                                    return Text('${snapshot.data}', style: TextStyle(fontSize: 17.0, color: Colors.green),);
                                    /*
                                    return Container(
                                        margin:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                                        padding:  EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white)
                                        ),
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText('${snapshot.data}',textStyle: const TextStyle(
                                          fontSize: 17.0, color: Colors.green),),
                                          ],
                                          onTap: () {
                                            print("Tap Event");
                                          },
                                        ));
                                     */

                                  }
                                  return  Text('Ask me anything...', style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.green),);

                                },
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                  ),

                      SizedBox(height: MediaQuery.of(context).size.height*0.05),

                    ],
                  ),

                  SizedBox(width: MediaQuery.of(context).size.width*0.1,)
                ],
              ),


          SizedBox(height: MediaQuery.of(context).size.height*0.1,),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(width: MediaQuery.of(context).size.width*0.1),

              Column(
                children: [
                  ElevatedButton(
                    onPressed: _newConnect,
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30),
                      child: FittedBox(
                        child: Icon(Icons.house),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),

    //setState(() =>_newVoiceText = valasz);
                  ElevatedButton(
                  onPressed: () {
                    setState(() =>_newVoiceText = "What do you order?");
                    _startListening();
                    },
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30),
                      child: FittedBox(
                        child: Icon(Icons.speaker_notes),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),



              SizedBox(width: MediaQuery.of(context).size.width*0.1,),

              Column(
                children: [
                  //Text("Borravaló:"),
                  RainbowSlider(),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  //Text("Hangerő:"),
                  VolumeSilder(),
                ],
              ),


              SizedBox(width: MediaQuery.of(context).size.width*0.1,),


              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() =>_newVoiceText = "A beer is added to your cart?");
                      _startListening();
                    },
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30),
                      child: FittedBox(
                        child: Image.asset('assets/beer.png'),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      //shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),

                  ElevatedButton(
                    onPressed: () {
                      setState(() =>_newVoiceText = "A beer is added to your cart?");
                      _startListening();
                    },
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30),
                      child: FittedBox(
                        child: Image.asset('assets/ham.png'),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      //shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(width: MediaQuery.of(context).size.width*0.01,),

              Column(
                children: [
                  ElevatedButton(
                    onPressed: _startListening,
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30),
                      child: FittedBox(
                        child: Image.asset('assets/beer.png'),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      //shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                  ElevatedButton(
                    onPressed: _startListening,
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30),
                      child: FittedBox(
                        child: Image.asset('assets/ham.png'),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      //shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )




            ],
          ),




        ],
      ),
      ],
      ),


      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*
          Fluttertoast.showToast(
              msg: "Kezdheted a beszédet. Nyomd meg újra ha befejezted.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
           */
        },
        child:
        Icon(Icons.add),
      ),
       */



    );
  }



  @override
  void dispose() {
    //channel.sink.close();
    super.dispose(); // Ne felejtsd el meghívni a szülő dispose metódusát
  }
}


class RainbowSlider extends StatefulWidget {
  @override
  _RainbowSliderState createState() => _RainbowSliderState();
}

class _RainbowSliderState extends State<RainbowSlider> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 500,
          child: Slider(
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
            min: 0,
            max: 100,
          ),
        ),
        /*
        Container(
          width: 300,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
              ],
              stops: [
                0.0,
                0.25,
                0.5,
                0.75,
                1.0,
              ],
            ),
          ),
        ),
         */
        //SizedBox(height: 20),
        Text('Tip: $_sliderValue'),
      ],
    );
  }
}

class VolumeSilder extends StatefulWidget {
  @override
  _VolumeSilderState createState() => _VolumeSilderState();
}

class _VolumeSilderState extends State<VolumeSilder> {
  double _sliderValue = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 500,
          child: Slider(
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
            min: 0,
            max: 100,
          ),
        ),
        //SizedBox(height: 20),
        Text('Volume: $_sliderValue'),
      ],
    );
  }
}