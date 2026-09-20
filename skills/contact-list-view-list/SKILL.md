---
name: contact-list-view-list
description: >-
  Build an A-Z Flutter contact list with ContactListView. Use when adding
  ContactListView, grouping items with tag, setting itemExtent /
  startItemExtent / endItemExtent, startChildren / endChildren, or wiring
  itemBuilder. Do not invent a ScrollController, jumpTo, or name-sort API.
---

# contact_list_view list

Authoritative usage for `ContactListView<T>` in `contact_list_view` 2.0.2.
Signatures match the source and the package README.

Import:

```dart
import 'package:contact_list_view/contact_list_view.dart';
import 'package:material_ui/material_ui.dart';
```

Requires Flutter `>=3.44.0`. Theme widgets (`Theme`, `ListTile`, `ColorScheme`) come from `material_ui` after the 2.0.0 material split.

## Guidelines

- Always pass the six required arguments: `contactsList`, `itemExtent`, `startItemExtent`, `endItemExtent`, `tag`, `itemBuilder`.
- Pass `startItemExtent` and `endItemExtent` even when `startChildren` / `endChildren` stay empty (`const <Widget>[]`).
- `startChildren` and `endChildren` are ordinary `Widget`s, not slivers. Do not wrap them in `SliverToBoxAdapter`. Every start child shares `startItemExtent`; every end child shares `endItemExtent`; every contact row shares `itemExtent`.
- `itemBuilder` is `Widget Function(T model)`. It does not receive `BuildContext` or an index.
- `tag` is `String Function(T model)`. Identical strings share a section. The package does **not** derive A–Z or `#` for you. Call `tag` only for a stable string; it is invoked again when sections are sorted.
- Section order: lexicographic `tag.compareTo`, except a section whose tag is exactly `'#'` is always last. Items inside a section keep `contactsList` insertion order (the in-section `sort` compares `tag` values, which are equal inside a group).
- Rebuild grouping by changing `contactsList` and calling `setState` on the parent. `ContactListView` rebuilds groups in `didUpdateWidget`.
- `ContactListView` owns its `ScrollController` and `CustomScrollView`. There is no constructor parameter for an external controller, and no public `jumpTo` / `scrollToIndex`.
- Prefer styling through `ContactListView` builders. For builder typedefs and standalone `ContactIndexBar` / `ContactCursor` / `ContactStickyHeader`, load the `contact-list-view-widgets` skill.

## Do not use

- `startSlivers` / `endSlivers` (renamed in 1.4.0 to `startChildren` / `endChildren`)
- `showStickyHeader` (removed in 1.1.0)
- Passing `itemBuilder: (context, index) { ... }`
- Sorting names inside `ContactListView` — it does not sort by name
- Importing `package:contact_list_view/package/flutter_sticky_header/...` from app code

## Minimal compiling example

```dart
import 'package:contact_list_view/contact_list_view.dart';
import 'package:material_ui/material_ui.dart';

class Contact {
  const Contact(this.name);
  final String name;
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key, required this.contacts});

  final List<Contact> contacts;

  static String tagOf(Contact contact) {
    final String raw = contact.name.trim();
    if (raw.isEmpty) return '#';
    final String upper = raw[0].toUpperCase();
    return RegExp(r'[A-Z]').hasMatch(upper) ? upper : '#';
  }

  @override
  Widget build(BuildContext context) {
    return ContactListView<Contact>(
      contactsList: contacts,
      itemExtent: 40,
      startItemExtent: 48,
      endItemExtent: 24,
      tag: tagOf,
      itemBuilder: (Contact contact) => ListTile(
        dense: true,
        minTileHeight: 40,
        title: Text(contact.name),
      ),
      startChildren: const [
        ListTile(dense: true, title: Text('New friends')),
      ],
      endChildren: [
        Center(child: Text('${contacts.length} contacts')),
      ],
    );
  }
}
```

Match row height to `itemExtent` (here both `40`). Match each start/end child height to `startItemExtent` / `endItemExtent`.

## Full member lists

- [ContactListView](references/contact-list-view.md) — constructor, every field, `createState`
- [ContactListModel](references/contact-list-model.md) — grouping record created internally
