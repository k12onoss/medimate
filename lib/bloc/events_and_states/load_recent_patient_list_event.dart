import 'package:medimate/bloc/patient_bloc.dart';

class LoadRecentPatientListEvent extends PatientEvent {}

class LoadingRecentPatientListState extends PatientState {}

class LoadRecentPatientListSuccessState extends PatientState
{
  final List list;

  LoadRecentPatientListSuccessState (this.list);
}

class LoadRecentPatientListFailState extends PatientState
{
  final error;

  LoadRecentPatientListFailState(this.error);
}