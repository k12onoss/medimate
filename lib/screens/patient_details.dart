import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/show_patient_details_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';

class PatientDetails extends StatelessWidget
{
  const PatientDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: const Text('Patient Details')),
      body: BlocBuilder<PatientBloc, PatientState>
        (
        builder: (context, state)
        {
          if (state is LoadingPatientDetailsListState)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          else if (state is LoadPatientDetailsListSuccessState)
          {
            List detailsList = state.patientDetailsList;

            return Column
              (
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                ListTile
                  (
                  title: Padding
                    (
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text
                      (
                      detailsList[0]['name'].toString().toUpperCase(),
                      style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Padding
                    (
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text
                      (
                      detailsList[0]['contact'],
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                _detailsListView(detailsList)
              ],
            );
          }
          return Container();
        }
      ),
    );
  }

  Widget _detailsListView(List detailsList)
  {
    return Expanded
      (
        child: ListView.builder
          (
            itemCount: detailsList.length,
            itemBuilder: (context, index) => _detailsCard(detailsList, index, context)
        )
    );
  }

  Widget _detailsCard(List detailsList, int index, BuildContext context)
  {
    final day = detailsList[index]['DOA'].toString().substring(8, 10);

    final String monthString;
    switch (detailsList[index]['DOA'].toString().substring(5, 7))
    {
      case '01': {
        monthString = 'Jan';
      } break;
      case '02': {
        monthString = 'Feb';
      } break;
      case '03': {
        monthString = 'March';
      } break;
      case '04': {
        monthString = 'April';
      } break;
      case '05': {
        monthString = 'May';
      } break;
      case '06': {
        monthString = 'June';
      } break;
      case '07': {
        monthString = 'July';
      } break;
      case '08': {
        monthString = 'Aug';
      } break;
      case '09': {
        monthString = 'Sep';
      } break;
      case '10': {
        monthString = 'Oct';
      } break;
      case '11': {
        monthString = 'Nov';
      } break;
      case '12': {
        monthString = 'Dec';
      } break;
      default: {
        monthString = '';
      }
    }

    final date = '$day $monthString';

    return Padding
      (
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row
        (
        children:
        [
          Container
            (
            height: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            decoration: ShapeDecoration
              (
                color: Theme.of(context).colorScheme.primary,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)))
            ),
            child: RotatedBox
              (
              quarterTurns: -1,
              child: Text
                (
                date,
                style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          ),
          Expanded
            (
            child: Card
              (
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
              child: ListTile
                (
                title: Text
                  (
                  detailsList[index]['illness'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text
                  (
                  detailsList[index]['prescription'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
