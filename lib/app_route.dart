import 'package:flutter/material.dart';
import 'package:flutter_video/video_list.dart';

import 'fullscreen_play.dart';

class AppRoute extends NavigatorObserver {
  AppRoute._internal();
  static final AppRoute _appRoute = AppRoute._internal();
  factory AppRoute() => _appRoute;

  /// 静态路由（无参数）
  static final Map<String, WidgetBuilder> _routes = {
    VideoList.routeName: (_) => VideoList(),
  };
  Map<String, WidgetBuilder> get routes => _routes;

  /// 带参数路由
  Route<dynamic> generateRoute(RouteSettings settings) {
    MaterialPageRoute targetPage;
//    if(settings.name == FullscreenPlay.routeName) {
//      final ProfilePageArgs args = settings.arguments;
//      targetPage = MaterialPageRoute(
//        settings: settings,
//        builder: (context) {
//          return ProfilePage(args);
//        },
//      );
//    }

  }
}

AppRoute appRoute = AppRoute();