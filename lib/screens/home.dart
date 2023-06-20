import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/restore_previous_state_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/bloc/theme_cubit.dart';
import 'package:medimate/screens/all_patient_list.dart';
import 'package:medimate/screens/dashboard.dart';

class Home extends StatelessWidget {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    PatientState? dashboardState;
    PatientState? allPatientListState;

    void changePage(int index) {
      _currentIndex.value = index;
      _pageController.jumpToPage(index);

      final bloc = BlocProvider.of<PatientBloc>(context);

      if (index == 0) {
        allPatientListState = bloc.state;
        bloc.add(RestorePreviousStateEvent(dashboardState!));
      } else if (index == 1) {
        dashboardState = bloc.state;
        if (allPatientListState == null) {
          bloc.add(LoadAllPatientListEvent());
        } else {
          bloc.add(RestorePreviousStateEvent(allPatientListState!));
        }
      }
    }

    PreferredSizeWidget appBar() {
      return AppBar(
        title: ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (context, index, _) {
            if (index == 0) {
              return const Text('MediMate');
            } else if (index == 1) {
              return const Text('All Patients');
            }
            return Container();
          },
        ),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) => IconButton(
              onPressed: () {
                BlocProvider.of<ThemeCubit>(context).toggleTheme();
              },
              icon: themeMode == ThemeMode.system
                  ? const Icon(Icons.brightness_auto)
                  : (themeMode == ThemeMode.light
                      ? const Icon(Icons.light_mode)
                      : const Icon(Icons.nights_stay)),
            ),
          )
        ],
      );
    }

    Widget pageView() {
      return PageView(
        controller: _pageController,
        onPageChanged: (index) => changePage(index),
        children: const [
          Dashboard(),
          AllPatientList(),
        ],
      );
    }

    Widget bottomNavigationBar() {
      return ValueListenableBuilder(
        valueListenable: _currentIndex,
        builder: (context, index, _) => BottomNavigationBar(
          currentIndex: index,
          showSelectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_rounded),
              activeIcon: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.dashboard_rounded),
                label: const Text('Dashboard'),
              ),
              label: 'Dashboard',
              tooltip: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list_alt_rounded),
              activeIcon: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text('All patients'),
              ),
              label: 'All patients',
              tooltip: 'All patients',
            )
          ],
          onTap: changePage,
        ),
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: pageView(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }
}
