import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medimate/data/database.dart';
import 'package:medimate/data/visit.dart';

class AllPatientsBloc extends Bloc<AllPatientsEvent, AllPatientsState> {
  AllPatientsBloc() : super(LoadingAllPatientsState()) {
    on(
      (event, emit) async {
        final database = Database();

        if (event is LoadAllPatientsEvent) {
          emit(LoadingAllPatientsState());

          try {
            final recentVisits = await database.getAllPatients();
            emit(
              LoadAllPatientsSuccessState(allPatients: recentVisits),
            );
          } catch (error) {
            emit(LoadAllPatientsFailState(error as Error));
          }
        } else if (event is SearchPatientEvent) {
          emit(SearchingPatientState());

          try {
            final patients = await database.searchPatient(event.name);

            emit(SearchPatientSuccessState(patients));
          } catch (error) {
            emit(SearchPatientFailState(error as Error));
          }
        }
      },
    );
  }
}

abstract class AllPatientsEvent {}

class LoadAllPatientsEvent extends AllPatientsEvent {}

class SearchPatientEvent extends AllPatientsEvent {
  String name;

  SearchPatientEvent(this.name);
}

abstract class AllPatientsState {}

class LoadingAllPatientsState extends AllPatientsState {}

class LoadAllPatientsSuccessState extends AllPatientsState {
  List<Visit> allPatients;

  LoadAllPatientsSuccessState({required this.allPatients});
}

class LoadAllPatientsFailState extends AllPatientsState {
  final Error error;

  LoadAllPatientsFailState(this.error);
}

class SearchingPatientState extends AllPatientsState {}

class SearchPatientSuccessState extends AllPatientsState {
  final List<Visit> patients;

  SearchPatientSuccessState(this.patients);
}

class SearchPatientFailState extends AllPatientsState {
  Error error;

  SearchPatientFailState(this.error);
}
