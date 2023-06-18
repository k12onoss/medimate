import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/bloc/theme_cubit.dart';
import 'package:medimate/models/custom_theme.dart';
import 'package:medimate/models/router_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routerDelegate = MyRouterDelegate();
    MyRouterDelegate.put(routerDelegate);

    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          final CustomTheme customTheme = CustomTheme();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              statusBarBrightness: mode == ThemeMode.system
                  ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark
                  : mode == ThemeMode.dark
                      ? Brightness.light
                      : Brightness.dark,
              statusBarIconBrightness: mode == ThemeMode.system
                  ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark
                  : mode == ThemeMode.dark
                      ? Brightness.light
                      : Brightness.dark,
              systemNavigationBarIconBrightness: mode == ThemeMode.system
                  ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark
                  : mode == ThemeMode.dark
                      ? Brightness.light
                      : Brightness.dark,
            ),
            child: MaterialApp(
              title: 'MediMate',
              restorationScopeId: 'medimate',
              themeMode: mode,
              theme: customTheme.lightTheme(),
              darkTheme: customTheme.darkTheme(),
              home: BlocProvider<PatientBloc>(
                create: (context) => PatientBloc()
                  ..add(
                    LoadRecentPatientListEvent(DateTime.now().toString()),
                  ),
                child: Router(
                  routerDelegate: routerDelegate,
                  backButtonDispatcher: RootBackButtonDispatcher(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
