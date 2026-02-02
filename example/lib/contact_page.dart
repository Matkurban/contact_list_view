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

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      userList.addAll(
        List.generate(
          26,
          (i) => User(
            userID: i.toString(),
            nickname: "${String.fromCharCode(97 + i).toLowerCase()}$i",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('ContactList'), centerTitle: true, toolbarHeight: 48),
      body: EasyRefresh(
        onRefresh: onRefresh,
        child: ContactListView<User>(
          contactsList: userList,
          tag: getTag,
          showStickyHeader: true,
          sticky: true,
          startSlivers: [
            SliverToBoxAdapter(child: ListTile(dense: true, title: Text('新的朋友'))),
            SliverToBoxAdapter(child: ListTile(dense: true, title: Text('我的群聊'))),
            SliverToBoxAdapter(child: ListTile(dense: true, title: Text('群通知'))),
          ],
          endSlivers: [SliverToBoxAdapter(child: Center(child: Text('总共${userList.length}位好友')))],
          itemBuilder: (User model) {
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
