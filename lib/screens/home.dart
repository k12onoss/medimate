import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/all_patients_bloc.dart';
import 'package:medimate/bloc/theme_cubit.dart';
import 'package:medimate/screens/all_patients_view.dart';
import 'package:medimate/screens/dashboard_view.dart';

class Home extends StatelessWidget {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    AllPatientsState? allPatientsState;

    void changePage(int index) {
      _currentIndex.value = index;
      _pageController.jumpToPage(index);

      if (index == 0) {
        allPatientsState = BlocProvider.of<AllPatientsBloc>(context).state;
      }
      if (index == 1) {
        if (allPatientsState == null) {
          BlocProvider.of<AllPatientsBloc>(context).add(LoadAllPatientsEvent());
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
          DashboardView(),
          AllPatientsView(),
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
