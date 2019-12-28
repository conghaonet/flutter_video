import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/const.dart';
import 'package:flutter_video/video_entity.dart';
import 'package:flutter_video/video_item.dart';
import 'package:video_player/video_player.dart';

class VideoList extends StatefulWidget {
  static const routeName = '/video_list';
  static FullscreenVideo fullscreenVideo;
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('视频列表'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: videosUrl.length,
          itemBuilder: (context, index) {
            return VideoItem(VideoEntity(videosUrl[index], thumbnails[index]));
          },
        ),
      ),

    );
  }
}

class FullscreenVideo {
  VideoEntity entity;
  VideoPlayerController controller;
  FullscreenVideo(this.entity, this.controller);
}
