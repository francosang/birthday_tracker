import 'dart:typed_data';

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
      create: (context) => ContactsCubit(
        context.read(),
        context.read(),
      )..load(),
      child: ContactsView(),
    );
  }
}

class ContactsFilterButton extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<ContactsFilter>> popupMenuKey;

  const ContactsFilterButton({super.key, required this.popupMenuKey});

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((ContactsCubit bloc) => bloc.state.filter);
    return PopupMenuButton<ContactsFilter>(
      key: popupMenuKey,
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
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}

class ContactsView extends StatelessWidget {
  final _filterButtonGlobalKey =
      GlobalKey<PopupMenuButtonState<ContactsFilter>>();

  ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(onPressed: () {
            context.read<ContactsCubit>().refresh();
          }, icon: const Icon(Icons.refresh)),
          ContactsFilterButton(popupMenuKey: _filterButtonGlobalKey),
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
                  "No contacts found.",
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            } else if (state.filteredContacts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No contacts found for the filter selected.",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _filterButtonGlobalKey.currentState?.showButtonMenu();
                      },
                      child: const Text('Change Filter'),
                    ),
                  ],
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
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: ListTile(
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
            : const Text(
                'Missing birthday date',
                maxLines: 1,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
        leading: ContactAvatar(
          photoOrThumbnail: contact.thumbnail,
        ),
        trailing: TextButton(
          child: const Text('Add birthday'),
          onPressed: () {},
        ),
      ),
    );
  }
}

class ContactAvatar extends StatelessWidget {
  final Uint8List? photoOrThumbnail;
  final double radius;
  final IconData defaultIcon;

  const ContactAvatar({
    super.key,
    this.photoOrThumbnail,
    this.radius = 32.0,
    this.defaultIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    final photoOrThumbnail = this.photoOrThumbnail;
    if (photoOrThumbnail != null) {
      return CircleAvatar(
        backgroundImage: MemoryImage(photoOrThumbnail),
        radius: radius,
      );
    }
    return CircleAvatar(
      radius: radius,
      child: Icon(defaultIcon),
    );
  }
}
