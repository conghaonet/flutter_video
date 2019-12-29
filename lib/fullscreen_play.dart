import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/video_entity.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlay extends StatefulWidget {
  static const routeName = '/fullscreen_play';
  final VideoEntity entity;
  final VideoPlayerController controller;
  FullscreenPlay(this.entity, this.controller, {Key key}): super(key: key);

  @override
  _FullscreenPlayState createState() => _FullscreenPlayState();
}

class _FullscreenPlayState extends State<FullscreenPlay> {
  VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _listener = () {
      setState(() {

      });
    };
    widget.controller.addListener(_listener);
  }
  @override
  Widget build(BuildContext context) {
    String currentPositionLabel = '${widget.controller.value.position.inMinutes.toString().padLeft(2, '0')}'
        ':${(widget.controller.value.position.inSeconds%60).toString().padLeft(2,'0')}';
    String totalPositionLabel = '${widget.controller.value.duration.inMinutes.toString().padLeft(2, '0')}'
        ':${(widget.controller.value.duration.inSeconds%60).toString().padLeft(2,'0')}';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                  });
                },
                onDoubleTap: () {
                  Navigator.pop(context);
                },
                child: VideoPlayer(widget.controller),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Text(
                      currentPositionLabel,
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: widget.controller.value.duration.inSeconds.toDouble(),
                        value: widget.controller.value.position.inSeconds.toDouble(),
                        onChanged: (newPosition) {
                          setState(() {
                            widget.controller.seekTo(Duration(seconds: newPosition.toInt()));
                          });
                        },
                      ),
                    ),
                    Text(
                      totalPositionLabel,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }
}