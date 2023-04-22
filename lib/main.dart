import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/nav_cubit.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/bloc/theme_cubit.dart';
import 'package:medimate/custom_theme.dart';
import 'package:medimate/screens/app_navigator.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  MyApp({Key? key}) : super(key: key);

  final CustomTheme _customTheme = CustomTheme();

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider
      (
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>
        (
        builder: (context, mode)
        {
          return MaterialApp
            (
            themeMode: mode,
            theme: _customTheme.lightTheme(),
            darkTheme: _customTheme.darkTheme(),

            home: MultiBlocProvider
              (
                providers:
                [
                  BlocProvider(create: (context) => PatientBloc()..add(LoadRecentPatientListEvent(DateTime.now().toString()))),
                  BlocProvider(create: (context) => NavCubit())
                ],
                child: const AppNavigator()
            ),
          );
        },
      ),
    );
  }
}