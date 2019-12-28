import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video/video_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final VideoEntity entity;
  VideoItem(this.entity, {Key key}): super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;
  int stackIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.entity.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: InkWell(
        onTap: () async {
          if(_controller.value.initialized) {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          } else {
            bool _isInitialed = await _initialController();
            if(_isInitialed) {
              setState(() {
                _controller.play();
                stackIndex = 1;
              });
            } else{
              Fluttertoast.showToast(msg: '视频加载失败，请重试。');
            }
          }
        },
        child: AspectRatio(
          aspectRatio: 16/9,
          child: IndexedStack(
            index: stackIndex,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              _buildThumbnail(),
              _buildPlayer(),
            ],
          ),
        ),
      ),
    );
  }

  _initialController() async {
    if(!_controller.value.initialized) {
      await _controller.initialize();
    }
    return _controller.value.initialized;
  }

  Widget _buildThumbnail() {
    return Image.asset(widget.entity.thumbnail);
  }

  Widget _buildPlayer() {
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}