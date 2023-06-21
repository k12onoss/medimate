import 'package:medimate/bloc/patient_bloc.dart';

class AddNewVisitEvent extends PatientEvent {
  Map visitDetails;

  AddNewVisitEvent(this.visitDetails);
}

class AddingNewVisitState extends PatientState {}

class AddNewVisitSuccessState extends PatientState {}

class AddNewVisitFailState extends PatientState {
  final Error error;

  AddNewVisitFailState(this.error);
}
