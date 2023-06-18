import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';

class LoadAllPatientListEvent extends PatientEvent {}

class LoadingAllPatientListState extends PatientState {}

class LoadAllPatientListSuccessState extends PatientState {
  final List<Visits> list;

  LoadAllPatientListSuccessState(this.list);
}

class LoadAllPatientListFailState extends PatientState {
  final Error error;

  LoadAllPatientListFailState(this.error);
}
