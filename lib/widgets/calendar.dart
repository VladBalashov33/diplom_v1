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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: myFormKey,
      child: Column(
        children: [
          DateRangeField(
            firstDate: DateTime(2010),
            lastDate: DateTime.now(),
            initialValue: myDateRange,
            enabled: true,
            decoration: InputDecoration(
              labelText: 'Временные границы постов',
              prefixIcon: const Icon(Icons.date_range),
              hintText: 'Выберете период',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.read<DetailUserBloc>().setDateRange(null);
                  myFormKey.currentState?.reset();
                  setState(() => myDateRange = null);
                },
              ),
            ),
            validator: (value) {
              if (value!.start.isBefore(DateTime.now())) {
                return 'Please enter a later start date';
              }
              return null;
            },
            onChanged: (value) {
              context.read<DetailUserBloc>().setDateRange(value);
              setState(() => myDateRange = value);
            },
          ),
        ],
      ),
    );
  }
}
