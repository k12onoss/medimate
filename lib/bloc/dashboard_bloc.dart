import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/data/database.dart';
import 'package:medimate/data/visit.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(LoadingRecentVisitsState()) {
    on<DashboardEvent>(
      (event, emit) async {
        final database = Database();

        if (event is LoadRecentVisitsEvent) {
          emit(LoadingRecentVisitsState());

          try {
            final recentVisits = await database.getRecentVisits(event.date);
            emit(
              LoadRecentVisitsSuccessState(
                recentVisits: recentVisits.reversed.toList(),
                date: event.date,
              ),
            );
          } catch (error) {
            emit(LoadRecentVisitsFailState(error as Error));
          }
        }
      },
    );
  }
}

abstract class DashboardEvent {}

class LoadRecentVisitsEvent extends DashboardEvent {
  String date;

  LoadRecentVisitsEvent(this.date);
}

abstract class DashboardState {}

class LoadingRecentVisitsState extends DashboardState {}

class LoadRecentVisitsSuccessState extends DashboardState {
  List<Visit> recentVisits;
  String date;

  LoadRecentVisitsSuccessState({
    required this.recentVisits,
    required this.date,
  });
}

class LoadRecentVisitsFailState extends DashboardState {
  final Error error;

  LoadRecentVisitsFailState(this.error);
}
