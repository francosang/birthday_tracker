import 'package:birthday_tracker/contacts/cubit/contacts_cubit.dart';
import 'package:birthday_tracker/contacts/cubit/contacts_state.dart';
import 'package:birthday_tracker/contacts/model/contact_filter.dart';
import 'package:contacts/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class ContactsPage extends StatelessWidget {
  static const routeName = '/contacts';

  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactsCubit(context.read())..load(),
      child: const ContactsView(),
    );
  }
}

class ContactsFilterButton extends StatelessWidget {
  const ContactsFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((ContactsCubit bloc) => bloc.state.filter);

    return PopupMenuButton<ContactsFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      onSelected: (filter) {
        context.read<ContactsCubit>().updateFilter(filter);
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: ContactsFilter.all,
            child: Text('Show all contacts'),
          ),
          PopupMenuItem(
            value: ContactsFilter.withBirthday,
            child: Text('Show only contacts with birthdays'),
          ),
          PopupMenuItem(
            value: ContactsFilter.missingBirthday,
            child: Text('Show only contacts with unknown birthdays'),
          )
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}

class ContactsView extends StatelessWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: const [
          ContactsFilterButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ContactsCubit, ContactsState>(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              final error = state.error;
              if (error != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(error),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state.contacts.isEmpty && state.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (!state.hasPermission) {
              return Center(
                child: ElevatedButton(
                  child: const Text(
                    "Grant access to Contacts",
                  ),
                  onPressed: () {
                    context.read<ContactsCubit>().load();
                  },
                ),
              );
            } else if (state.contacts.isEmpty) {
              return Center(
                child: Text(
                  "No contacts found with the selected filters.",
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final contact in state.filteredContacts)
                    ContactListTile(
                      contact: contact,
                      onTap: () {
                        // Navigator.of(context).push(
                        //   EditTodoPage.route(initialTodo: todo),
                        // );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    super.key,
    required this.contact,
    this.onTap,
  });

  final Contact contact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final birthday = contact.birthdays?.firstOrNull?.toString();
    return ListTile(
      key: Key('ContactListTile_${contact.id}'),
      onTap: onTap,
      title: Text(
        contact.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: birthday != null
          ? Text(
              birthday,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      leading: Checkbox(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        value: birthday != null,
        onChanged: null,
      ),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    );
  }
}
