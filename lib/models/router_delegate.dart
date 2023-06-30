import 'package:flutter/material.dart';
import 'package:medimate/screens/home.dart';
import 'package:medimate/screens/patient_history_view.dart';
import 'package:medimate/screens/update_visit_view.dart';

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  @override
  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  final _pages = <Page>[
    MaterialPage(
      child: Home(),
      key: const ValueKey('/home'),
      name: '/home',
    ),
  ];

  static late MyRouterDelegate? _myRouterDelegate;

  static void put(MyRouterDelegate myRouterDelegate) {
    _myRouterDelegate = myRouterDelegate;
  }

  static MyRouterDelegate find() {
    return _myRouterDelegate!;
  }

  void pushPage(String routeName, [Object? arguments]) {
    Widget child;

    switch (routeName) {
      case 'updateVisit':
        {
          child = UpdateVisitView();
        }
        break;
      case 'patientHistory':
        {
          child = const PatientHistoryView();
        }
        break;
      default:
        {
          child = Home();
        }
    }

    _pages.add(
      MaterialPage(
        child: child,
        key: ValueKey(routeName),
        name: routeName,
        arguments: arguments,
      ),
    );

    notifyListeners();
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _pages.removeLast();

      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    popRoute();
    return true;
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {}

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }
}
