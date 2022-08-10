import 'package:contacts_feature/src/contacts_cubit.dart';
import 'package:contacts_feature/src/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  static const routeName = '/contacts';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactsCubit(context.read())..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<ContactsCubit, ContactsState>(
            builder: (context, state) {
              final error = state.error;
              final list = state.contacts;
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownButton<FilterType>(
                    // Read the selected themeMode from the controller
                    value: state.filterType,
                    // Call the updateThemeMode method any time the user selects a theme.
                    onChanged: context.read<ContactsCubit>().updateFilter,
                    items: const [
                      DropdownMenuItem(
                        value: FilterType.all,
                        child: Text('Show all contacts'),
                      ),
                      DropdownMenuItem(
                        value: FilterType.withBirthdays,
                        child: Text('Show only contacts with birthdays'),
                      ),
                      DropdownMenuItem(
                        value: FilterType.withoutBirthdays,
                        child: Text('Show only contacts with unknown birthdays'),
                      )
                    ],
                  ),
                  if (error != null) Text(error),
                  if (error == null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(list[index].name);
                        },
                      ),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
