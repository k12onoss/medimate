import 'package:medimate/bloc/patient_bloc.dart';

class RestorePreviousStateEvent extends PatientEvent {
  PatientState state;

  RestorePreviousStateEvent(this.state);
}
