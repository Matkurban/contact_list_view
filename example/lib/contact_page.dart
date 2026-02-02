import 'dart:math';

import 'package:contact_list_view/contact_list_view.dart';
import 'package:example/user.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final List<User> userList = [];

  @override
  void initState() {
    super.initState();
    userList.addAll(
      List.generate(
        26,
        (i) =>
            User(userID: i.toString(), nickname: "${String.fromCharCode(97 + i).toLowerCase()}$i"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('ContactList'), centerTitle: true, toolbarHeight: 48),
      body: ContactListView<User>(
        contactsList: userList,
        tag: getTag,
        contactListItemBuilder: (User model) {
          return ListTile(
            dense: true,
            minTileHeight: 40,
            contentPadding: .symmetric(horizontal: 16, vertical: 2),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: colorScheme.primary, borderRadius: .circular(4)),
              alignment: .center,
              child: Text(
                getTag(model),
                style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
              ),
            ),
            title: Text(model.nickname),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          setState(() {
            userList.add(User(userID: "123", nickname: 'Kurban${Random().nextInt(100)}'));
          });
          debugPrint("userList:${userList.length.toString()}");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
