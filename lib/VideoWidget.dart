import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool toggle;

  VideoWidget({
    required this.controller,
    required this.toggle,
  });

  @override
  _VideoWidgetState createState() => _VideoWidgetState(controller: controller, toggle: toggle);
}



class _VideoWidgetState extends State<VideoWidget> {
   VideoPlayerController controller;
   bool toggle=true;

  _VideoWidgetState({
    required this.controller,
    required this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    return    Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
      ),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(height: 20),
              Container(

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: controller.value.isInitialized
                    ?
                toggle ? Container(
                  width: 410,
                  height: 400,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                  ),
                ) : Container(
                  color: Colors.black,
                  width: 410,
                  height: 400,
                )

                    : Container(),
              ),
        ],
          ),
            ],
      ),
    );
  }
}
