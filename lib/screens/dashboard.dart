import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/enter_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/show_visit_details_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/date.dart';
import 'package:medimate/data/visits.dart';
import 'package:medimate/models/router_delegate.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PatientBloc, PatientState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  if (state is LoadRecentPatientListSuccessState)
                    _datePicker(context, state.date),
                  Expanded(child: _topCard(context)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (state is LoadingRecentPatientListState)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (state is LoadRecentPatientListSuccessState &&
                  state.list.isNotEmpty)
                _recentVisitsList(state.list)
              else if (state is LoadRecentPatientListSuccessState)
                const Center(
                  child: Text("No visits yet!"),
                )
              else if (state is LoadRecentPatientListFailState)
                Center(
                  child: Text('${state.error}'),
                )
            ],
          );
        },
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _datePicker(BuildContext context, String date) {
    final String month = Date().setMonth(int.parse(date.substring(5, 7)));
    DateTime? selectedDate = DateTime.tryParse(date);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 7, 10),
      child: TextButton(
        onPressed: () async {
          selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.parse(date),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );

          if (selectedDate != null &&
              selectedDate.toString() != date &&
              context.mounted) {
            BlocProvider.of<PatientBloc>(context)
                .add(LoadRecentPatientListEvent(selectedDate.toString()));
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.primary,
          ),
          fixedSize: MaterialStateProperty.all(const Size(85, 85)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.substring(8, 10),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(
              month,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _topCard(BuildContext context) {
    final state = BlocProvider.of<PatientBloc>(context).state;

    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 10, 10, 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: const Text(
            'Patients Visited',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: state is LoadRecentPatientListSuccessState
              ? (state.list.isNotEmpty
                  ? Text(state.list.length.toString())
                  : const Text('0'))
              : null,
          leadingAndTrailingTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _recentVisitsList(List<Visits> patientList) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'Recent visits',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: patientList.length,
              itemBuilder: (context, index) {
                return _recentVisitsCard(patientList, index, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentVisitsCard(
    List<Visits> patientList,
    int index,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<PatientBloc>(context)
              .add(ShowVisitDetailsEvent(patientList[index]));
          MyRouterDelegate.find().pushPage('/visitDetails');
        },
        child: Card(
          child: ListTile(
            title: Text(
              patientList[index].name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              patientList[index].illness,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        MyRouterDelegate.find().pushPage('/addPatient');
        BlocProvider.of<PatientBloc>(context).add(EnterPatientDetailsEvent());
      },
      child: const Icon(Icons.add),
    );
  }
}
