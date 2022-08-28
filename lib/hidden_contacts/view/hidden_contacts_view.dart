
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../contacts/view/contacts_view.dart';
import '../cubit/hidden_contacts_cubit.dart';
import '../cubit/hidden_contacts_state.dart';

class HiddenContactsPage extends StatelessWidget {
  static const routeName = '/contacts/hidden';

  const HiddenContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HiddenContactsCubit(
            context.read(),
            context.read(),
          )..load(),
        ),
      ],
      child: const HiddenContactsView(),
    );
  }
}

class HiddenContactsView extends StatelessWidget {
  const HiddenContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    print(HiddenContactsView);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden contacts'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HiddenContactsCubit, HiddenContactsState>(
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
          BlocListener<HiddenContactsCubit, HiddenContactsState>(
            listenWhen: (previous, current) =>
                previous.lastShownContact != current.lastShownContact &&
                current.lastShownContact != null,
            listener: (context, state) {
              final shownContact = state.lastShownContact!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      'Contact "${shownContact.name}" shown again.',
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<HiddenContactsCubit>()
                            .undoShowContact(shownContact);
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: const ContactsOverview(),
      ),
    );
  }
}

class ContactsOverview extends StatelessWidget {
  const ContactsOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HiddenContactsCubit, HiddenContactsState>(
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
                context.read<HiddenContactsCubit>().load();
              },
            ),
          );
        } else if (state.contacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No hidden contacts',
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('Go back'),
                ),
              ],
            ),
          );
        }

        return CupertinoScrollbar(
          child: ListView(
            children: state.contacts.map((contact) {
              return ContactListTile(
                contact: contact,
                onDismissed: (_) {
                  try {
                    context.read<HiddenContactsCubit>().showContact(contact);
                  } catch (err) {
                    print(err);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
