import 'package:flutter/material.dart';

import 'contacts_controller.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/contacts';

  final ContactsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) {
            final error = controller.error;
            if (error != null) {
              return Text(error);
            }

            return ListView.builder(
              itemCount: controller.contacts.allOthers.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(controller.contacts.allOthers[index].name);
              },
            );
          },
        ),
      ),
    );
  }
}
