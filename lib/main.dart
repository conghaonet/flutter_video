import 'package:flutter_video/video_list.dart';
import 'package:flutter/material.dart';

import 'app_route.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 定义静态路由，不能传递参数
      routes: appRoute.routes,
      //动态路由，可传递参数
      onGenerateRoute: appRoute.generateRoute,
      navigatorObservers: [
        appRoute,
      ],
      theme: ThemeData(
        buttonColor: Theme.of(context).primaryColor,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      title: 'Video Demo',
      home: Builder(builder: ((context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Video Demo'),
          ),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Text('插件Demo'),
                    onPressed: () {

                    },
                  ),
                  RaisedButton(
                    child: Text('视频列表'),
                    onPressed: () {
                      Navigator.pushNamed(context, VideoList.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      })),
    );
  }

}