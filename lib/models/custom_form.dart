import 'package:country_dial_code/country_dial_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/add_new_visit_event.dart';
import 'package:medimate/bloc/events_and_states/updating_visit_details_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';

class CustomForm {
  final _formKey = GlobalKey<FormState>();
  final _parameters = [
    'name',
    'contact',
    'age',
    'illness',
    'prescription',
    'period',
    'DOA',
    'fee'
  ];
  final Map<String, dynamic> visitDetails;
  String enterText;

  CustomForm({
    required this.visitDetails,
    required this.enterText,
  });

  Widget form(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 620,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _parameters.length,
                itemBuilder: (context, index) {
                  return _formFields(index, context);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  if (enterText == 'Add') {
                    BlocProvider.of<PatientBloc>(context)
                        .add(AddNewVisitEvent(visitDetails));
                  } else if (enterText == 'Update') {
                    BlocProvider.of<PatientBloc>(context)
                        .add(UpdateVisitDetailsEvent(visitDetails));
                  }
                }
              },
              child: Text(enterText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formFields(int index, BuildContext context) {
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
      TextInputType.datetime,
      TextInputType.number
    ];
    const icons = [
      Icon(Icons.person),
      Icon(Icons.phone),
      Icon(Icons.cake),
      Icon(Icons.sick),
      Icon(Icons.medication),
      Icon(Icons.access_time),
      Icon(Icons.today),
      Icon(Icons.currency_rupee)
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
      child: TextFormField(
        initialValue: enterText == 'Add'
            ? label == 'DOA'
                ? DateTime.now().toString().substring(0, 10)
                : null
            : enterText == 'Update'
                ? visitDetails[parameter].toString()
                : null,
        readOnly: enterText == 'Update' && (index == 0 || index == 1),
        textCapitalization: TextCapitalization.words,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icons[index],
          prefixIconColor: Theme.of(context).colorScheme.primary,
          prefix: parameter == 'contact' ? _dropdownMenuButton(context) : null,
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
            ? value!.length < 10
                ? 'Enter a valid phone number'
                : null
            : value!.isEmpty
                ? 'This field cannot be empty'
                : null,
        onSaved: (value) {
          visitDetails.update(
            parameter,
            (value) => value as Object,
            ifAbsent: () => value!,
          );
        },
        textInputAction: index == _parameters.length - 1
            ? TextInputAction.done
            : TextInputAction.next,
        keyboardType: keyboardTypes[index],
      ),
    );
  }

  Widget _dropdownMenuButton(BuildContext context) {
    final countryLocales = View.of(context).platformDispatcher.locales;
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
    final ValueNotifier selectedCode = ValueNotifier(
      CountryDialCode.fromCountryCode(countryLocales.first.countryCode!)
          .dialCode,
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
          selectedCode.value = value;
        },
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
