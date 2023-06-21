import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/restore_previous_state_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/screens/add_visit.dart';
import 'package:medimate/screens/home.dart';
import 'package:medimate/screens/patient_details.dart';
import 'package:medimate/screens/visit_details.dart';

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
  late PatientState? _previousHomeState;
  late PatientState? _previousPatientDetailsState;
  String? _pageThatPushedVisitDetails;

  static late MyRouterDelegate? _myRouterDelegate;

  static void put(MyRouterDelegate myRouterDelegate) {
    _myRouterDelegate = myRouterDelegate;
  }

  static MyRouterDelegate find() {
    return _myRouterDelegate!;
  }

  void pushPage(String routeName, [Object? arguments]) {
    Widget child;
    final PatientBloc patientBloc =
        BlocProvider.of<PatientBloc>(navigatorKey!.currentContext!);

    switch (routeName) {
      case '/addVisit':
        {
          _previousHomeState = patientBloc.state;
          child = const AddVisit();
        }
        break;
      case '/patientDetails':
        {
          _previousHomeState = patientBloc.state;
          child = const PatientDetails();
        }
        break;
      case '/visitDetails':
        {
          _pageThatPushedVisitDetails = _pages.last.name;
          if (_pageThatPushedVisitDetails == '/home') {
            _previousHomeState = patientBloc.state;
          }
          if (_pageThatPushedVisitDetails == '/patientDetails') {
            _previousPatientDetailsState = patientBloc.state;
          }
          child = const VisitDetails();
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
      final Page poppedPage = _pages.removeLast();
      final PatientBloc patientBloc =
          BlocProvider.of<PatientBloc>(navigatorKey!.currentContext!);

      if (poppedPage.name == '/addVisit' ||
          (poppedPage.name == '/visitDetails' &&
              _pageThatPushedVisitDetails == '/home')) {
        patientBloc.add(RestorePreviousStateEvent(_previousHomeState!));
      }
      if (poppedPage.name == '/patientDetails') {
        patientBloc.add(RestorePreviousStateEvent(_previousHomeState!));
      }
      if (poppedPage.name == '/visitDetails' &&
          _pageThatPushedVisitDetails == '/patientDetails') {
        patientBloc
            .add(RestorePreviousStateEvent(_previousPatientDetailsState!));
      }

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
