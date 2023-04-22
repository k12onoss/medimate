import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/pop_to_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/pop_to_recent_patient_list_event.dart';
import 'package:medimate/bloc/nav_cubit.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/screens/add_patient.dart';
import 'package:medimate/screens/all_patient_list.dart';
import 'package:medimate/screens/dashboard.dart';
import 'package:medimate/screens/patient_details.dart';

class AppNavigator extends StatelessWidget
{
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    PatientBloc patientBloc = BlocProvider.of<PatientBloc>(context);
    PatientState? previousDashboardState;
    PatientState? previousAllPatientListState;

    return BlocBuilder<NavCubit, String?>
      (
      builder: (context, routeName)
      {
        if (routeName == '/dashboard')
        {
          previousDashboardState = patientBloc.state;
        }
        if (routeName == '/allPatientList')
        {
          previousAllPatientListState = patientBloc.state;
        }

        print(routeName);

        return Navigator
          (
          pages:
           [
            const MaterialPage
              (
              child: Dashboard(),
              name: '/dashboard'
            ),

            if (routeName == '/allPatientList' || routeName == '/patientDetails')
              const MaterialPage
                (
                child: AllPatientList(),
                name: '/allPatientList'
              ),

            if (routeName == '/addPatient')
              MaterialPage
                (
                child: AddPatient(),
                name: '/addPatient'
              ),
            if (routeName == '/patientDetails')
              const MaterialPage
                (
                child: PatientDetails(),
                name: '/patientDetails'
              )
          ],
          onPopPage: (route, result)
          {
            final navCubit = BlocProvider.of<NavCubit>(context);

            if (route.settings.name == '/addPatient' || route.settings.name == '/allPatientList')
            {
              print('Yes');
              patientBloc.add(PopToRecentPatientListEvent(previousDashboardState!));
              navCubit.navigateTo('/dashboard');
            }
            if (route.settings.name == '/patientDetails')
            {
              patientBloc.add(PopToAllPatientListEvent(previousAllPatientListState!));
              navCubit.navigateTo('/allPatientList');
            }

            return route.didPop(result);
          },
        );
      }
    );
  }
}