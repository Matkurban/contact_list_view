import 'dart:math';

import 'package:contact_list_view/contact_list_view.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:example/user.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final List<User> userList = [];

  static const int _initialUserCount = 120;

  List<User> _buildTestUsers({required int count, int startIndex = 0}) {
    return List.generate(count, (i) {
      final int index = startIndex + i;
      final String letter = String.fromCharCode(97 + (index % 26));
      return User(userID: index.toString(), nickname: '$letter$index');
    });
  }

  @override
  void initState() {
    super.initState();
    userList.addAll(_buildTestUsers(count: _initialUserCount));
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      userList.addAll(_buildTestUsers(count: 26, startIndex: userList.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('ContactList'),
        centerTitle: true,
        toolbarHeight: 48,
      ),
      body: EasyRefresh(
        onRefresh: onRefresh,
        child: ContactListView<User>(
          contactsList: userList,
          itemExtent: 40,
          startItemExtent: 48,
          endItemExtent: 24,
          tag: getTag,
          sticky: true,
          startChildren: [
            ListTile(dense: true, title: Text('新的朋友')),
            ListTile(dense: true, title: Text('我的群聊')),
            ListTile(dense: true, title: Text('群通知')),
          ],
          endChildren: [Center(child: Text('总共${userList.length}位好友'))],
          itemBuilder: (User model) {
            return ListTile(
              dense: true,
              minTileHeight: 40,
              contentPadding: .symmetric(horizontal: 16, vertical: 2),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: .circular(4),
                ),
                alignment: .center,
                child: Text(
                  getTag(model),
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              title: Text(model.nickname),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          setState(() {
            userList.add(
              User(userID: "123", nickname: 'Kurban${Random().nextInt(100)}'),
            );
          });
          debugPrint("userList:${userList.length.toString()}");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
