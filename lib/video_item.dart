import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video/app_event_bus.dart';
import 'package:flutter_video/fullscreen_play.dart';
import 'package:flutter_video/video_entity.dart';
import 'package:flutter_video/video_event.dart';
import 'package:flutter_video/video_list.dart';
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
  int _stackIndex = 0;
  bool _isAutoDispose = false;
  VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () async {
      if(_isAutoDispose) {
        _controller.dispose();
        return;
      }
    };
    if(VideoList.fullscreenVideo != null && VideoList.fullscreenVideo.entity.videoUrl == widget.entity.videoUrl) {
      _controller = VideoList.fullscreenVideo.controller;
      VideoList.fullscreenVideo = null;
      _stackIndex = 1;
    }

    eventBus.on<VideoEvent>().listen((event){
      if(event.videoEntity != widget.entity) {
        if(_controller != null && !_isAutoDispose && _controller.value.initialized) {
          if(mounted) {
            setState(() {
              _controller.pause();
              _isAutoDispose = true;
              _stackIndex = 0;
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
          index: _stackIndex,
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
    _isAutoDispose = false;
    eventBus.fire(VideoEvent(widget.entity));
    try {
      await _controller?.dispose();
    } catch(e) {
      print(e.toString());
    }
    _controller = VideoPlayerController.network(widget.entity.videoUrl);
    _controller.addListener(_listener);
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
            _stackIndex = 1;
          });
        } else{
          Fluttertoast.showToast(msg: '视频加载失败，请重试。');
        }
      },
      child: Image.asset(widget.entity.thumbnail),
    );
  }

  Widget _buildPlayer() {
    if(_controller == null || _isAutoDispose) {
      return Container();
    } else {
      return  GestureDetector(
        onTap: _controller == null || _isAutoDispose ? null : () {
          if(_controller.value.initialized) {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          }
        },
        onDoubleTap: () {
          VideoList.fullscreenVideo = FullscreenVideo(widget.entity, _controller);
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return FullscreenPlay(widget.entity, _controller);
          }));
        },
        child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    if(VideoList.fullscreenVideo == null || VideoList.fullscreenVideo.entity.videoUrl != widget.entity.videoUrl) {
      _controller?.dispose();
    }
    super.dispose();
  }
}