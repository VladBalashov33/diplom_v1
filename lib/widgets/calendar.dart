import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:diplom/bloc/detail_user_bloc/detail_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CalendarButton extends StatefulWidget {
  @override
  _CalendarButtonState createState() => _CalendarButtonState();
}

GlobalKey<FormState> myFormKey = new GlobalKey();

class _CalendarButtonState extends State<CalendarButton> {
  DateTimeRange? myDateRange;

  void _submitForm() {
    final FormState? form = myFormKey.currentState;
    form!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: myFormKey,
      child: Column(
        children: [
          DateRangeField(
            enabled: true,
            decoration: const InputDecoration(
              labelText: 'Date Range',
              prefixIcon: Icon(Icons.date_range),
              hintText: 'Please select a start and end date',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.start.isBefore(DateTime.now())) {
                return 'Please enter a later start date';
              }
              return null;
            },
            onSaved: (value) {
              context.read<DetailUserBloc>().setDateRange(value);
              setState(() => myDateRange = value!);
            },
            onChanged: (value) {
              context.read<DetailUserBloc>().setDateRange(value);
              setState(() => myDateRange = value!);
            },
          ),
        ],
      ),
    );
  }
}
