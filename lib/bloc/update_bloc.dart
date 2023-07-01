import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/data/database.dart';
import 'package:medimate/data/visit.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateBloc() : super(EditingState()) {
    on(
      (event, emit) async {
        final database = Database();

        if (event is UpdateVisitEvent) {
          emit(UpdatingVisitState());

          try {
            await database.updateVisit(event.visit);
            emit(UpdateVisitSuccessState());
          } catch (error) {
            emit(UpdateVisitFailState(error as Error));
          }
        } else if (event is ResetEvent) {
          emit(EditingState());
        }
      },
    );
  }
}

abstract class UpdateEvent {}

class UpdateVisitEvent extends UpdateEvent {
  Visit visit;

  UpdateVisitEvent(this.visit);
}

class ResetEvent extends UpdateEvent {}

abstract class UpdateState {}

class EditingState extends UpdateState {}

class UpdatingVisitState extends UpdateState {}

class UpdateVisitSuccessState extends UpdateState {}

class UpdateVisitFailState extends UpdateState {
  final Error error;

  UpdateVisitFailState(this.error);
}
