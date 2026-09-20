# contact_list_view

[English](README.md) | [中文](README_zh.md)

A Flutter sliver-based contact list with A–Z index navigation, sticky section headers, and builders for the index bar, cursor, and headers.

## Features

- Sticky section headers with an optional `stickyHeaderBuilder`
- Alphabet index bar with a drag cursor
- Customizable decorations, text styles, animations, and alignments
- `SliverFixedExtentList` layout for large contact sets

|                         ScreenShot                         |                                                  ScreenShot                                                   |
| :--------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------: |
| ![Screenshot 1](doc/images/Screenshot_20260202_222935.jpg) | [![Video preview](doc/images/Screenshot_20260202_224751.jpg)](doc/videos/Screenrecording_20260202_222939.mp4) |

## Requirements

- Dart `^3.12.0`
- Flutter `>=3.44.0`
- Theme widgets (`Scaffold`, `ListTile`, `Theme`) come from [`material_ui`](https://pub.dev/packages/material_ui) after the Flutter material split

## Getting started

Add to `pubspec.yaml`:

```yaml
dependencies:
  contact_list_view: ^2.0.2
```

Then run:

```bash
flutter pub get
```

This package ships agent skills. After the dependency is in your app, install them with:

```bash
dart run skills@ get
```

## Usage

`ContactListView` requires `contactsList`, `itemExtent`, `startItemExtent`, `endItemExtent`, `tag`, and `itemBuilder`. Pass the two header/footer extents even when `startChildren` / `endChildren` stay empty. Those children are ordinary `Widget`s, not slivers.

`tag` is the only grouping key. Identical strings share a section. A section whose tag is exactly `'#'` is sorted last. The widget does not sort contacts by name.

```dart
import 'package:contact_list_view/contact_list_view.dart';
import 'package:material_ui/material_ui.dart';

class Contact {
  const Contact(this.name);
  final String name;
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key, required this.contacts});

  final List<Contact> contacts;

  static String tagOf(Contact contact) {
    final String raw = contact.name.trim();
    if (raw.isEmpty) return '#';
    final String upper = raw[0].toUpperCase();
    return RegExp(r'[A-Z]').hasMatch(upper) ? upper : '#';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ContactListView<Contact>(
        contactsList: contacts,
        itemExtent: 56,
        startItemExtent: 48,
        endItemExtent: 24,
        tag: tagOf,
        itemBuilder: (Contact contact) => ListTile(
          title: Text(contact.name),
        ),
        startChildren: const [
          ListTile(dense: true, title: Text('New friends')),
        ],
        endChildren: [
          Center(child: Text('${contacts.length} contacts')),
        ],
      ),
    );
  }
}
```

Match each contact row height to `itemExtent`, each start child to `startItemExtent`, and each end child to `endItemExtent`.

The list owns its `ScrollController` and `CustomScrollView`. There is no constructor parameter for an external controller, and no public `jumpTo` / `scrollToIndex`.

Update the list by changing `contactsList` and calling `setState` on the parent.

## Customization

Style the default chrome through `ContactListView`, or replace it with builders:

- `stickyHeaderBuilder` — `Widget Function(String tag, bool isPinned)`. When set, default header fields (`stickyHeaderHeight`, padding, decoration, text style, alignment, header animation) are unused.
- `cursorBuilder` — `Widget Function(String title)`. `cursorContainerSize` still positions the cursor (`top = offset.dy - cursorContainerSize / 2`).
- `indexBarBoxDecorationBuilder` / `indexBarTextStyleBuilder` — `BoxDecoration` / `TextStyle` from `bool isSelected`.
- `indexBarAlignment` aligns the whole rail; `indexBarItemAlignment` aligns one letter cell.

A runnable app is in `example/`.

## Additional information

- [中文文档](README_zh.md)
- Example app: `example/`
- Issues and pull requests are welcome
