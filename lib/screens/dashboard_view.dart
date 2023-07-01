import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/dashboard_bloc.dart';
import 'package:medimate/data/date.dart';
import 'package:medimate/data/visit.dart';
import 'package:medimate/models/router_delegate.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => BlocProvider.of<DashboardBloc>(context).add(
          LoadRecentVisitsEvent(DateTime.now().toString().substring(0, 10)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    final date = state is LoadRecentVisitsSuccessState
                        ? state.date
                        : DateTime.now().toString().substring(0, 10);
                    return _datePicker(context, date);
                  },
                ),
                _topCard(context),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is LoadingRecentVisitsState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadRecentVisitsSuccessState &&
                    state.recentVisits.isNotEmpty) {
                  return _recentVisitsList(state.recentVisits);
                } else if (state is LoadRecentVisitsSuccessState) {
                  return const Center(
                    child: Text("No visits yet!"),
                  );
                } else if (state is LoadRecentVisitsFailState) {
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
            BlocProvider.of<DashboardBloc>(context).add(
              LoadRecentVisitsEvent(
                selectedDate.toString().substring(0, 10),
              ),
            );
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
            Flexible(
              flex: 2,
              child: Text(
                date.substring(8),
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
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
    final state = BlocProvider.of<DashboardBloc>(context).state;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7, 10, 10, 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: const Text(
              'Patients Visited',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: state is LoadRecentVisitsSuccessState
                ? state.recentVisits.isNotEmpty
                    ? Text(state.recentVisits.length.toString())
                    : const Text('0')
                : null,
            leadingAndTrailingTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _recentVisitsList(List<Visit> patientList) {
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
    List<Visit> patientList,
    int index,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: GestureDetector(
        onTap: () {
          final argument = {
            'visit': patientList[index],
            'enterText': 'Update',
          };
          MyRouterDelegate.find().pushPage('updateVisit', argument);
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
              patientList[index].symptom!,
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
    final argument = {
      'visit': Visit(
        name: '',
        contact: '',
        age: 0,
        gender: '',
        doa: '',
        fee: 0,
      ),
      'enterText': 'Add',
    };

    return FloatingActionButton(
      onPressed: () =>
          MyRouterDelegate.find().pushPage('updateVisit', argument),
      child: const Icon(Icons.add),
    );
  }
}
