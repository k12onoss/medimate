import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/screens/dashboard.dart';

class NavCubit extends Cubit<String?>
{
  PatientState? previousPatientState;

  NavCubit() : super('/dashboard');

  void navigateTo(String routeName)
  {
    emit(routeName);
  }

  void goBack() => emit(null);
}