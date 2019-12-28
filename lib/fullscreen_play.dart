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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: VideoPlayer(widget.controller),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}