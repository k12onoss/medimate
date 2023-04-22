import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/bloc/nav_cubit.dart';
import 'package:medimate/bloc/events_and_states/enter_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/load_all_patient_list_event.dart';
import 'package:medimate/bloc/theme_cubit.dart';

class Dashboard extends StatelessWidget
{
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: _appBar(context),
        body: BlocBuilder<PatientBloc, PatientState>
          (
          builder: (context, state)
          {
            return Column
              (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
              [
                // _datePicker(context),
                _topCard(context),
                const SizedBox(height: 10,),
                if (state is LoadingRecentPatientListState) const Center(child: CircularProgressIndicator(),)
                else if(state is LoadRecentPatientListSuccessState) _appointmentsList(state.list)
                else if (state is LoadRecentPatientListFailState) Center(child: Text('${state.error}'),)
              ]
            );
          },
        ),
        floatingActionButton: _floatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _bottomNavigationBar(context)
    );
  }

  PreferredSizeWidget _appBar(BuildContext context)
  {
    return AppBar
      (
      title: const Text('MediMate'),
      actions:
      [
        BlocBuilder<ThemeCubit, ThemeMode>
          (
          builder: (context, themeMode) => IconButton
            (
            onPressed: ()
            {
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
            },
            icon: themeMode == ThemeMode.system
                ? const Icon(Icons.auto_mode)
                : (themeMode == ThemeMode.light
                ? const Icon(Icons.light_mode) : const Icon(Icons.nights_stay)),
          ),
        )
      ],
    );
  }

  Widget _datePicker(BuildContext context)
  {
    return IconButton
      (
        onPressed: () async
        {
          await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2025));
        },
        icon: const Icon(Icons.calendar_month)
    );
  }

  Widget _topCard(BuildContext context)
  {
    final state = BlocProvider.of<PatientBloc>(context).state;

    return Padding
      (
      padding: const EdgeInsets.all(15),
      child: Card
        (
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile
          (
          leading: CircleAvatar
            (
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon
              (
              Icons.person,
              color: Theme.of(context).scaffoldBackgroundColor,
            )
          ),
          title: const Text
            (
            'Patients visited',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: state is LoadRecentPatientListSuccessState ? Text(state.list[0].length.toString()): null,
        )
      ),
    );
  }

  Widget _appointmentsList(List patientList)
  {
    return Expanded
      (
      child: Column
        (
        children:
        [
          Row
            (
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
            const [
              Text
                (
                'Recent appointments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text
                (
                'See all',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          Expanded
            (
            child: ListView.builder
              (
              itemCount: patientList[0].length,
              itemBuilder: (context, index)
              {
                return _appointmentsCard(patientList, index, context);
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentsCard(List patientList, int index, BuildContext context)
  {
    return Padding
      (
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: GestureDetector
        (
        onTap: ()
        {
        // BlocProvider.of<PatientBloc>(context).add(ShowPatientDetailsEvent());
        // BlocProvider.of<NavCubit>(context).showPatientDetails();
        },
        child:Card
          (
          child: ListTile
            (
            title: Text
              (
              patientList[0][index]['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text
              (
              patientList[0][index]['illness'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
        ),
      )
    );
  }

  Widget _floatingActionButton(BuildContext context)
  {
    return FloatingActionButton
      (
      onPressed: ()
      {
        final patientBloc = BlocProvider.of<PatientBloc>(context);
        BlocProvider.of<NavCubit>(context).navigateTo('/addPatient');
        patientBloc.add(EnterPatientDetailsEvent());
      },
      child: const Icon(Icons.add),);
  }

  Widget _bottomNavigationBar(BuildContext context)
  {
    return BottomNavigationBar
      (
      showSelectedLabels: false,
      items:
        [
          BottomNavigationBarItem
            (
              icon: Row
                (
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  const Icon(Icons.home_filled),
                  const SizedBox(width: 5,),
                  Text('Home', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                ],
              ),
              label: 'Dashboard'
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: 'All patients')
        ],
      onTap: (index)
      {
        if (index == 1)
          {
            BlocProvider.of<PatientBloc>(context).add(LoadAllPatientListEvent());
            BlocProvider.of<NavCubit>(context).navigateTo('/allPatientList');
          }
      },
    );
  }
}