import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/bloc/theme_cubit.dart';
import 'package:medimate/models/custom_theme.dart';
import 'package:medimate/models/router_delegate.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final routerDelegate = MyRouterDelegate();
    MyRouterDelegate.put(routerDelegate);

    return BlocProvider
      (
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>
        (
        builder: (context, mode)
        {
          final CustomTheme customTheme = CustomTheme();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          return AnnotatedRegion<SystemUiOverlayStyle>
            (
            value: SystemUiOverlayStyle
              (
              statusBarColor: Colors.transparent,
              statusBarBrightness: mode == ThemeMode.dark ? Brightness.dark: Brightness.light,
              systemNavigationBarColor: Colors.transparent,
            ),
            child: MaterialApp
              (
              title: 'MediMate',
              themeMode: mode,
              theme: customTheme.lightTheme(),
              darkTheme: customTheme.darkTheme(),

              home: MultiBlocProvider
                (
                  providers:
                  [
                    BlocProvider<PatientBloc>(create: (context) => PatientBloc()..add(LoadRecentPatientListEvent(DateTime.now().toString()))),
                  ],
                  child: Router(routerDelegate: routerDelegate, backButtonDispatcher: RootBackButtonDispatcher())
              ),
            ),
          );
        },
      ),
    );
  }
}