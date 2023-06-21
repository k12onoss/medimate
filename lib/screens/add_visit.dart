import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/add_new_visit_event.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/models/custom_form.dart';
import 'package:medimate/models/router_delegate.dart';

class AddVisit extends StatelessWidget {
  const AddVisit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add visit'),
      ),
      body: Stack(
        children: [
          CustomForm(visitDetails: {}, enterText: 'Add').form(context),
          BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              if (state is AddingNewVisitState) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is AddNewVisitSuccessState) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: AlertDialog(
                    content: const Text('Visit added successfully!'),
                    contentTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    actions: [
                      TextButton(
                        onPressed: () {
                          MyRouterDelegate.find().popRoute();
                          BlocProvider.of<PatientBloc>(context).add(
                            LoadRecentPatientListEvent(
                              DateTime.now().toString(),
                            ),
                          );
                        },
                        child: const Text('Great!'),
                      )
                    ],
                  ),
                );
              } else if (state is AddNewVisitFailState) {
                return Center(
                  child: Text(
                    'Adding new visit failed with the following error:\n${state.error}',
                  ),
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
