import 'package:medimate/bloc/patient_bloc.dart';

class AddNewPatientEvent extends PatientEvent
{
  Map patientDetails;

  AddNewPatientEvent(this.patientDetails);
}

class AddingNewPatientState extends PatientState {}

class AddNewPatientSuccessState extends PatientState {}

class AddNewPatientFailState extends PatientState
{
  final error;

  AddNewPatientFailState (this.error);
}