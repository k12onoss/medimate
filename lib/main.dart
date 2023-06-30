import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import 'package:medimate/bloc/all_patients_bloc.dart';
import 'package:medimate/bloc/dashboard_bloc.dart';
import 'package:medimate/bloc/patient_history_bloc.dart';
import 'package:medimate/bloc/theme_cubit.dart';
import 'package:medimate/bloc/update_bloc.dart';
import 'package:medimate/data/visit.dart';
import 'package:medimate/models/custom_theme.dart';
import 'package:medimate/models/router_delegate.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Isar.open([VisitSchema], directory: dir.path, name: 'visits');
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
              debugShowCheckedModeBanner: false,
              themeMode: mode,
              theme: customTheme.lightTheme(),
              darkTheme: customTheme.darkTheme(),
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<DashboardBloc>(
                    create: (context) => DashboardBloc(),
                  ),
                  BlocProvider<AllPatientsBloc>(
                    create: (context) => AllPatientsBloc(),
                  ),
                  BlocProvider<PatientHistoryBloc>(
                    create: (context) => PatientHistoryBloc(),
                  ),
                  BlocProvider<UpdateBloc>(create: (context) => UpdateBloc()),
                  BlocProvider<DashboardBloc>(
                    create: (context) => DashboardBloc(),
                  ),
                ],
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
