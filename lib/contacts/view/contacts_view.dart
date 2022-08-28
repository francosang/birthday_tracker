import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:birthday_tracker/contacts/cubit/contacts_cubit.dart';
import 'package:birthday_tracker/contacts/cubit/contacts_state.dart';
import 'package:birthday_tracker/contacts/model/contact_filter.dart';
import 'package:birthday_tracker/hidden_contacts/view/hidden_contacts_view.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactsCubit(
            context.read(),
            context.read(),
          )..load(),
        ),
      ],
      child: const ContactsView(),
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
        actions: [
          IconButton(
            onPressed: () {
              context.read<ContactsCubit>().refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 0) {
                Navigator.of(context)
                    .pushNamed(HiddenContactsPage.routeName)
                    .then((value) {
                  context.read<ContactsCubit>().refresh();
                });
              }
            },
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('Hidden contacts'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          )
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
          BlocListener<ContactsCubit, ContactsState>(
            listenWhen: (previous, current) =>
                previous.lastIgnoredContact != current.lastIgnoredContact &&
                current.lastIgnoredContact != null,
            listener: (context, state) {
              final ignoredContact = state.lastIgnoredContact!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Contact "${ignoredContact.name}" hidden.'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<ContactsCubit>()
                            .undoHideContact(ignoredContact);
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'Progress',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: BlocBuilder<ContactsCubit, ContactsState>(
                builder: (context, state) {
                  double? progress;
                  if (state.contacts.isNotEmpty) {
                    progress = ContactsFilter.knownBirthdays
                        .applyAll(state.contacts)
                        .length /
                        state.contacts.length;
                  }

                  return LinearProgressIndicator(
                    value: progress,
                  );
                },
              ),
            ),
            const Divider(),
            Expanded(
              child: ContactsOverview(
                onShowFilterPopUp: () {},
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<ContactsCubit, ContactsState>(
        buildWhen: (prev, cur) => prev.filter != cur.filter,
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: tabIndex(state.filter),
            onTap: (index) {
              context.read<ContactsCubit>().updateFilter(tabFilter(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Known Birthdays',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hide_source),
                label: 'Missing Birthdays',
              ),
            ],
          );
        },
      ),
    );
  }
}

class ContactsOverview extends StatelessWidget {
  final VoidCallback? onShowFilterPopUp;

  const ContactsOverview({Key? key, this.onShowFilterPopUp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      buildWhen: (prev, cur) => prev != cur,
      builder: (context, state) {
        if (state.contacts.isEmpty && state.loading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (!state.hasPermission) {
          return Center(
            child: ElevatedButton(
              child: const Text(
                'Grant access to Contacts',
              ),
              onPressed: () {
                context.read<ContactsCubit>().load();
              },
            ),
          );
        } else if (state.contacts.isEmpty) {
          return Center(
            child: Text(
              'No contacts found.',
              style: Theme.of(context).textTheme.caption,
            ),
          );
        } else if (state.filteredContacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No contacts found for the filter selected.',
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onShowFilterPopUp,
                  child: const Text('Change Filter'),
                ),
              ],
            ),
          );
        }

        return CupertinoScrollbar(
          child: ListView(
            children: state.filteredContacts.map((contact) {
              return ContactListTile(
                contact: contact,
                onDismissed: (_) {
                  try {
                    context.read<ContactsCubit>().hideContact(contact);
                  } catch (err) {
                    print(err);
                  }
                },
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode.input,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                    lastDate: DateTime.now(),
                  ).then((date) {
                    context.read<ContactsCubit>().addContactBirthday(
                      contact: contact,
                      birthDate: date,
                    );
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

final DateFormat formatter = DateFormat('MMMMd');

extension on DateTime {
  String format(DateFormat format) {
    return format.format(this);
  }
}

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    super.key,
    required this.contact,
    this.onDismissed,
    this.onTap,
  });

  final Contact contact;
  final VoidCallback? onTap;
  final DismissDirectionCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    final birthday = contact.birthdays?.firstOrNull?.format(formatter);
    return Dismissible(
      key: Key('${ContactListTile}_dismissible_${contact.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.person_off,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        key: Key('ContactListTile_${contact.id}'),
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
        trailing: contact.birthdays?.isEmpty ?? true
            ? TextButton(
                onPressed: onTap,
                child: const Text('Add birthday'),
              )
            : null,
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
