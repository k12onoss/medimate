import 'dart:ui';

import 'package:country_dial_code/country_dial_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/dashboard_bloc.dart';
import 'package:medimate/bloc/patient_history_bloc.dart';
import 'package:medimate/bloc/update_bloc.dart';
import 'package:medimate/data/visit.dart';
import 'package:medimate/models/router_delegate.dart';

class UpdateVisitView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _parameters = [
    'name',
    'contact',
    'age',
    'gender',
    'symptom',
    'medicine',
    'prescription',
    'advice',
    'period',
    'doa',
    'fee',
  ];

  UpdateVisitView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments! as Map;
    final visit = arguments['visit'] as Visit;
    final enterText = arguments['enterText'].toString();
    final visitDetails = visit.toMap();

    final countryLocales = View.of(context).platformDispatcher.locales;
    final ValueNotifier<String> selectedCode = ValueNotifier<String>(
      CountryDialCode.fromCountryCode(countryLocales.first.countryCode!)
          .dialCode,
    );

    Widget dropdownMenuButton(BuildContext context) {
      final dropDownItems = List.generate(
        countryLocales.length,
        (index) => DropdownMenuItem(
          value: CountryDialCode.fromCountryCode(
            countryLocales[index].countryCode!,
          ).dialCode,
          child: Text(
            CountryDialCode.fromCountryCode(
              countryLocales[index].countryCode!,
            ).dialCode,
          ),
        ),
      );

      return ValueListenableBuilder(
        valueListenable: selectedCode,
        builder: (context, code, _) => DropdownButton(
          elevation: 0,
          borderRadius: BorderRadius.circular(14),
          underline: Container(),
          dropdownColor: Theme.of(context).cardColor,
          value: code,
          items: dropDownItems,
          onChanged: (value) {
            selectedCode.value = value!;
          },
          icon: const Icon(Icons.arrow_drop_down),
        ),
      );
    }

    Widget formFields(int index, BuildContext context) {
      final String parameter = _parameters[index];
      final String label =
          parameter.replaceRange(0, 1, parameter.substring(0, 1).toUpperCase());
      final keyboardTypes = [
        TextInputType.name,
        TextInputType.phone,
        TextInputType.number,
        TextInputType.text,
        TextInputType.text,
        TextInputType.text,
        TextInputType.text,
        TextInputType.text,
        TextInputType.text,
        TextInputType.datetime,
        TextInputType.number
      ];
      const icons = [
        Icon(Icons.person),
        Icon(Icons.phone),
        Icon(Icons.cake),
        Icon(Icons.wc),
        Icon(Icons.sick),
        Icon(Icons.medication),
        Icon(Icons.medical_information),
        Icon(Icons.sentiment_very_satisfied),
        Icon(Icons.access_time),
        Icon(Icons.today),
        Icon(Icons.currency_rupee)
      ];

      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
        child: TextFormField(
          initialValue: enterText == 'Add'
              ? parameter == 'doa'
                  ? DateTime.now().toString().substring(0, 10)
                  : null
              : enterText == 'Update'
                  ? parameter == 'contact'
                      ? visitDetails[parameter].toString().substring(3)
                      : visitDetails[parameter].toString()
                  : null,
          readOnly: enterText == 'Update' && (index == 0),
          textCapitalization: TextCapitalization.words,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icons[index],
            prefixIconColor: Theme.of(context).colorScheme.primary,
            prefix: parameter == 'contact' ? dropdownMenuButton(context) : null,
            filled: true,
            fillColor: Theme.of(context).cardTheme.color,
            isCollapsed: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).cardTheme.color!,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) => index == 1
              ? value!.length != 10
                  ? 'Enter a valid phone number'
                  : null
              : index >= 4 && index <= 8
                  ? null
                  : value!.isEmpty
                      ? 'This field cannot be empty'
                      : null,
          onSaved: (value) {
            if (value != null) {
              visitDetails.update(
                parameter,
                (_) {
                  return parameter == 'contact'
                      ? selectedCode.value + value
                      : value;
                },
                ifAbsent: () => value,
              );
            }
          },
          textInputAction: index == _parameters.length - 1
              ? TextInputAction.done
              : TextInputAction.next,
          keyboardType: keyboardTypes[index],
        ),
      );
    }

    Widget form(BuildContext context) {
      return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _parameters.length,
                itemBuilder: (context, index) {
                  return formFields(index, context);
                },
              ),
            ),
            SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();

                    BlocProvider.of<UpdateBloc>(context)
                        .add(UpdateVisitEvent(Visit.fromMap(visitDetails)));
                  }
                },
                child: Text(enterText),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$enterText visit'),
      ),
      body: Stack(
        children: [
          form(context),
          BlocBuilder<UpdateBloc, UpdateState>(
            builder: (context, state) {
              if (state is UpdatingVisitState) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 5,
                    sigmaX: 5,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is UpdateVisitSuccessState) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: AlertDialog(
                    content: Text('Visit ${enterText}ed successfully!'),
                    contentTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    actions: [
                      TextButton(
                        onPressed: () {
                          MyRouterDelegate.find().popRoute();
                          BlocProvider.of<UpdateBloc>(context)
                              .add(ResetEvent());

                          if (enterText == 'Add') {
                            BlocProvider.of<DashboardBloc>(context).add(
                              LoadRecentVisitsEvent(
                                DateTime.now().toString().substring(0, 10),
                              ),
                            );
                          }

                          if (enterText == 'Update') {
                            BlocProvider.of<PatientHistoryBloc>(context).add(
                              LoadPatientHistoryEvent(
                                name: visit.name,
                                contact: visit.contact,
                              ),
                            );
                          }
                        },
                        child: const Text('Great!'),
                      )
                    ],
                  ),
                );
              } else if (state is UpdateVisitFailState) {
                return Center(
                  child: Text(
                    '${enterText}ing new visit failed with the following error:\n${state.error}',
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
