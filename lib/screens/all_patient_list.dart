import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/search_patient_event.dart';
import 'package:medimate/bloc/events_and_states/show_patient_details_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';
import 'package:medimate/models/router_delegate.dart';

class AllPatientList extends StatelessWidget {
  const AllPatientList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _searchBar(context),
          BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              if (state is LoadingAllPatientListState ||
                  state is SearchingPatientState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoadAllPatientListSuccessState) {
                return _patientGrid(state.list);
              } else if (state is SearchPatientSuccessState) {
                return _patientGrid(state.patients);
              } else if (state is LoadAllPatientListFailState) {
                return Center(
                  child: Text(state.error.toString()),
                );
              } else if (state is SearchPatientFailState) {
                return Center(
                  child: Text(state.error.toString()),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: SearchBar(
        hintText: 'Search patients',
        leading: Icon(
          Icons.search_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        elevation: MaterialStateProperty.all(0),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).cardTheme.color),
        surfaceTintColor:
            MaterialStateProperty.all(Theme.of(context).cardTheme.color),
        side: MaterialStateProperty.resolveWith(
          (state) => state.contains(MaterialState.focused)
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : BorderSide(
                  width: 3,
                  color: Theme.of(context).cardTheme.color!,
                ),
        ),
        onChanged: (name) =>
            BlocProvider.of<PatientBloc>(context).add(SearchPatientEvent(name)),
      ),
    );
  }

  Widget _patientGrid(List<Visits> patientList) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: patientList.length,
        itemBuilder: (context, index) {
          return _patientCard(patientList, index, context);
        },
      ),
    );
  }

  Widget _patientCard(
    List<Visits> patientList,
    int index,
    BuildContext context,
  ) {
    final String name = patientList[index].name;
    final String contact = patientList[index].contact;

    return GestureDetector(
      onTap: () {
        BlocProvider.of<PatientBloc>(context)
            .add(ShowPatientDetailsEvent(name, contact));
        final routerDelegate = MyRouterDelegate.find();
        routerDelegate.pushPage('/patientDetails');
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          isThreeLine: true,
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            maxLines: 1,
          ),
          subtitle: Text(
            contact,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            softWrap: false,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        ),
      ),
    );
  }
}
