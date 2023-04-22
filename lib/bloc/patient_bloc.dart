import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/load_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/pop_to_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/search_patient_event.dart';
import 'package:medimate/bloc/events_and_states/add_new_patient_event.dart';
import 'package:medimate/bloc/events_and_states/enter_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/show_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/pop_to_recent_patient_list_event.dart';
import 'package:medimate/patient_repository.dart';

abstract class PatientEvent {}

abstract class PatientState {}

class PatientBloc extends Bloc<PatientEvent, PatientState>
{
  final _patientRepository = PatientRepository();

  PatientBloc(): super(LoadingRecentPatientListState())
  {
    on
      (
      (event, emit) async
      {
        if (event is LoadRecentPatientListEvent)
        {
          emit(LoadingRecentPatientListState());

          try
          {
            final allPatientList = await _patientRepository.getPatientList();
            List recentPatientList = [], recentPatientDetailsList = [], recentPatientPresList = [];

            allPatientList[0].map((e) => e['DOA'] == '2023-04-13T00:00:00.000Z' ? recentPatientDetailsList.add(e): 0);
            allPatientList[1].map((e) => e['DOA'] == '2023-04-13T00:00:00.000Z' ? recentPatientPresList.add(e): 0);
            recentPatientList.add(recentPatientDetailsList);
            recentPatientList.add(recentPatientPresList);

            print(recentPatientList);

            // emit (LoadRecentPatientListSuccessState(recentPatientList));
            emit(LoadRecentPatientListSuccessState(allPatientList));
          }
          catch (e)
          {
            emit(LoadRecentPatientListFailState(e));
          }
        }
        else if (event is LoadAllPatientListEvent)
        {
          emit(LoadingAllPatientListState());

          try
          {
            final allPatientList = await _patientRepository.getPatientList();
            emit (LoadAllPatientListSuccessState(allPatientList));
          }
          catch (e)
          {
            emit(LoadAllPatientListFailState(e));
          }
        }
        else if (event is SearchPatientEvent)
        {
          emit (SearchingPatientState());

          try
          {
            List patientsList = await _patientRepository.searchPatient(event.name);
            emit(SearchPatientSuccessState(patientsList));
          }
          catch (e)
          {
            emit(SearchPatientFailState(e));
          }
        }
        else if (event is EnterPatientDetailsEvent)
        {
          emit(EnteringPatientDetailsState());
        }
        else if (event is AddNewPatientEvent)
        {
          emit(AddingNewPatientState());

          try
          {
            await _patientRepository.addPatient(event.patientDetails);
            emit(AddNewPatientSuccessState());
          }
          catch (e)
          {
            emit(AddNewPatientFailState(e));
          }
        }
        else if (event is ShowPatientDetailsEvent)
        {
          emit(LoadingPatientDetailsListState());

          try
          {
            List patientDetails = await _patientRepository.getPatientHistory(event.name, event.contact);
            emit(LoadPatientDetailsListSuccessState(patientDetails));
          }
          catch (e)
          {
            emit(LoadPatientDetailsListFailState(e));
          }
        }
        else if (event is PopToRecentPatientListEvent)
        {
          emit(event.state);
        }
        else if (event is PopToAllPatientListEvent)
        {
          emit(event.state);
        }
      }
    );
  }
}