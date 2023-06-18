import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';

class ShowPatientDetailsEvent extends PatientEvent {
  String name;
  String contact;

  ShowPatientDetailsEvent(this.name, this.contact);
}

class LoadingPatientDetailsListState extends PatientState {}

class LoadPatientDetailsListSuccessState extends PatientState {
  final List<Visits> patientDetailsList;

  LoadPatientDetailsListSuccessState(this.patientDetailsList);
}

class LoadPatientDetailsListFailState extends PatientState {
  final Error error;

  LoadPatientDetailsListFailState(this.error);
}

class ClearPatientDetailsListState extends PatientState {
  final list = [];
}
