import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/data/database.dart';
import 'package:medimate/data/visit.dart';

class PatientHistoryBloc
    extends Bloc<PatientHistoryEvent, PatientHistoryState> {
  PatientHistoryBloc() : super(LoadingPatientHistoryState()) {
    on(
      (event, emit) async {
        final database = Database();

        if (event is LoadPatientHistoryEvent) {
          emit(LoadingPatientHistoryState());

          try {
            final patientHistory = await database.getPatientHistory(
              event.name,
              event.contact,
            );
            emit(
              LoadPatientHistorySuccessState(
                patientHistory.reversed.toList(),
              ),
            );
          } catch (error) {
            emit(LoadPatientHistoryFailState(error as Error));
          }
        }
      },
    );
  }
}

abstract class PatientHistoryEvent {}

class LoadPatientHistoryEvent extends PatientHistoryEvent {
  String name;
  String contact;

  LoadPatientHistoryEvent({required this.name, required this.contact});
}

abstract class PatientHistoryState {}

class LoadingPatientHistoryState extends PatientHistoryState {}

class LoadPatientHistorySuccessState extends PatientHistoryState {
  final List<Visit> patientHistory;

  LoadPatientHistorySuccessState(this.patientHistory);
}

class LoadPatientHistoryFailState extends PatientHistoryState {
  final Error error;

  LoadPatientHistoryFailState(this.error);
}
