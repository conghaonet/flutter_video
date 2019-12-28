import 'package:flutter/material.dart';
import 'package:flutter_video/video_list.dart';

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

  }
}

AppRoute appRoute = AppRoute();