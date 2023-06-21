import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/updating_visit_details_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';
import 'package:medimate/models/custom_form.dart';
import 'package:medimate/models/router_delegate.dart';

class VisitDetails extends StatelessWidget {
  const VisitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final visit = ModalRoute.of(context)!.settings.arguments! as Visits;
    final visitDetails = {
      'name': visit.name,
      'contact': visit.contact,
      'age': visit.age,
      'illness': visit.illness,
      'prescription': visit.prescription,
      'period': visit.period,
      'DOA': visit.doa.substring(0, 10),
      'fee': visit.fee
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Details'),
      ),
      body: Stack(
        children: [
          CustomForm(visitDetails: visitDetails, enterText: 'Update')
              .form(context),
          BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              if (state is UpdatingVisitState) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is UpdateVisitSuccessState) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: AlertDialog(
                    content: const Text('Visit updated successfully!'),
                    contentTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    actions: [
                      TextButton(
                        onPressed: () => MyRouterDelegate.find().popRoute(),
                        child: const Text('Great!'),
                      )
                    ],
                  ),
                );
              } else if (state is UpdateVisitFailState) {
                return Center(
                  child: Text('${state.error}'),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
