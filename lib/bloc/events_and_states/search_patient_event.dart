import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';

class SearchPatientEvent extends PatientEvent {
  String name;

  SearchPatientEvent(this.name);
}

class SearchingPatientState extends PatientState {}

class SearchPatientSuccessState extends PatientState {
  final List<Visits> patients;

  SearchPatientSuccessState(this.patients);
}

class SearchPatientFailState extends PatientState {
  final Error error;

  SearchPatientFailState(this.error);
}
