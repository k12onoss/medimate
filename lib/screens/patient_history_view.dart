import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medimate/bloc/patient_history_bloc.dart';
import 'package:medimate/data/date.dart';
import 'package:medimate/data/visit.dart';
import 'package:medimate/models/router_delegate.dart';

class PatientHistoryView extends StatelessWidget {
  const PatientHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient History')),
      body: BlocBuilder<PatientHistoryBloc, PatientHistoryState>(
        builder: (context, state) {
          if (state is LoadingPatientHistoryState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadPatientHistorySuccessState) {
            final List<Visit> detailsList = state.patientHistory;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      detailsList[0].name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      detailsList[0].contact,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _detailsListView(detailsList)
              ],
            );
          } else if (state is LoadPatientHistoryFailState) {
            return Center(
              child: Text(state.error.toString()),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _detailsListView(List<Visit> detailsList) {
    return Expanded(
      child: ListView.builder(
        itemCount: detailsList.length,
        itemBuilder: (context, index) =>
            _detailsCard(detailsList, index, context),
      ),
    );
  }

  Widget _detailsCard(
    List<Visit> detailsList,
    int index,
    BuildContext context,
  ) {
    final day = detailsList[index].doa.substring(8, 10);

    final String month =
        Date().setMonth(int.parse(detailsList[index].doa.substring(5, 7)));

    final date = '$day $month';

    return GestureDetector(
      onTap: () {
        final argument = {'visit': detailsList[index], 'enterText': 'Update'};
        MyRouterDelegate.find().pushPage('updateVisit', argument);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Row(
          children: [
            Container(
              height: 102,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              child: RotatedBox(
                quarterTurns: -1,
                child: Text(
                  date,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    detailsList[index].symptom ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    detailsList[index].medicine ??
                        detailsList[index].prescription ??
                        detailsList[index].advice ??
                        '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
