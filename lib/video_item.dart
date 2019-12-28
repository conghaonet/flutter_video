import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video/app_event_bus.dart';
import 'package:flutter_video/video_entity.dart';
import 'package:flutter_video/video_event.dart';
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
  bool isAutoDispose = false;
  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () async {
      if(isAutoDispose) {
        _controller.dispose();
        return;
      }
//      if(_controller.value.position.inMilliseconds == _controller.value.duration.inMilliseconds) {
//        Fluttertoast.showToast(msg: '播放完成');
//        setState(() {
//          isAutoDispose = true;
//          stackIndex = 0;
//        });
//        await _controller.dispose();
//        setState(() {
//          _controller = null;
//        });
//      }
//      print('_controller.value is null = ${_controller.value == null}');
    };
    eventBus.on<VideoEvent>().listen((event){
      if(event.videoEntity != widget.entity) {
        if(_controller != null && !isAutoDispose && _controller.value.initialized) {
          if(mounted) {
            setState(() {
              _controller.pause();
              isAutoDispose = true;
              stackIndex = 0;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
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
    );
  }

  _initialController() async {
    isAutoDispose = false;
    eventBus.fire(VideoEvent(widget.entity));
    await _controller?.dispose();
    _controller = VideoPlayerController.network(widget.entity.videoUrl);
    _controller.addListener(listener);
    _controller.setLooping(true);
    await _controller.initialize();
    return _controller.value.initialized;
  }

  Widget _buildThumbnail() {
    return InkWell(
      onTap: () async {
        bool _isInitialed = await _initialController();
        if(_isInitialed) {
          setState(() {
            _controller.play();
            stackIndex = 1;
          });
        } else{
          Fluttertoast.showToast(msg: '视频加载失败，请重试。');
        }
      },
      child: Image.asset(widget.entity.thumbnail),
    );
  }

  Widget _buildPlayer() {
    if(_controller == null || isAutoDispose) {
      return Container();
    } else {
      return  GestureDetector(
      onTap: _controller == null || isAutoDispose ? null : () {
        if(_controller.value.initialized) {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        }
      },
        child: VideoPlayer(_controller),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}