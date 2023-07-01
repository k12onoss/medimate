import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/all_patients_bloc.dart';
import 'package:medimate/bloc/patient_history_bloc.dart';
import 'package:medimate/data/visit.dart';
import 'package:medimate/models/router_delegate.dart';

class AllPatientsView extends StatelessWidget {
  const AllPatientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => BlocProvider.of<AllPatientsBloc>(context)
            .add(LoadAllPatientsEvent()),
        child: Column(
          children: [
            _searchBar(context),
            BlocBuilder<AllPatientsBloc, AllPatientsState>(
              builder: (context, state) {
                if (state is LoadingAllPatientsState ||
                    state is SearchingPatientState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadAllPatientsSuccessState) {
                  if (state.allPatients.isEmpty) {
                    return const Center(
                      child: Text('No patients yet'),
                    );
                  }
                  return _patientGrid(state.allPatients);
                } else if (state is SearchPatientSuccessState) {
                  return _patientGrid(state.patients);
                } else if (state is LoadAllPatientsFailState) {
                  return Center(
                    child: Text('${state.error}'),
                  );
                } else if (state is SearchPatientFailState) {
                  return Center(
                    child: Text('${state.error}'),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
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
        onChanged: (name) => BlocProvider.of<AllPatientsBloc>(context)
            .add(SearchPatientEvent(name)),
      ),
    );
  }

  Widget _patientGrid(List<Visit> patientList) {
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
    List<Visit> patientList,
    int index,
    BuildContext context,
  ) {
    final String name = patientList[index].name;
    final String contact = patientList[index].contact;

    return GestureDetector(
      onTap: () {
        BlocProvider.of<PatientHistoryBloc>(context)
            .add(LoadPatientHistoryEvent(name: name, contact: contact));
        MyRouterDelegate.find().pushPage('patientHistory', {
          'name': name,
          'contact': contact,
        });
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
