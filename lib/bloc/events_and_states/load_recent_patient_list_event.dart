import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';

class LoadRecentPatientListEvent extends PatientEvent {
  String date;

  LoadRecentPatientListEvent(this.date);
}

class LoadingRecentPatientListState extends PatientState {}

class LoadRecentPatientListSuccessState extends PatientState {
  final List<Visits> list;
  final String date;

  LoadRecentPatientListSuccessState(this.list, this.date);
}

class LoadRecentPatientListFailState extends PatientState {
  final Error error;

  LoadRecentPatientListFailState(this.error);
}
