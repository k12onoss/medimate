import 'package:medimate/bloc/patient_bloc.dart';

class UpdateVisitDetailsEvent extends PatientEvent {
  Map<String, dynamic> visit;

  UpdateVisitDetailsEvent(this.visit);
}

class UpdatingVisitState extends PatientState {}

class UpdateVisitSuccessState extends PatientState {
  String name;
  String contact;

  UpdateVisitSuccessState(this.name, this.contact);
}

class UpdateVisitFailState extends PatientState {
  final Error error;

  UpdateVisitFailState(this.error);
}
