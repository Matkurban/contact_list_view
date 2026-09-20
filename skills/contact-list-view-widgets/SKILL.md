---
name: contact-list-view-widgets
description: >-
  Customize contact_list_view index bar, cursor, and sticky headers, or use
  ContactIndexBar, ContactCursor, and ContactStickyHeader standalone. Use when
  writing stickyHeaderBuilder, cursorBuilder, indexBarBoxDecorationBuilder,
  indexBarTextStyleBuilder, or the exported chrome widgets and typedefs.
---

# contact_list_view widgets

Authoritative API for the exported builders and chrome widgets in
`contact_list_view` 2.0.2. Prefer configuring these through `ContactListView`
parameters. Construct `ContactIndexBar`, `ContactCursor`, or `ContactStickyHeader`
only when composing a custom shell.

Import:

```dart
import 'package:contact_list_view/contact_list_view.dart';
import 'package:material_ui/material_ui.dart';
```

Standalone `ContactIndexBar` also needs `signals_flutter` for `FlutterSignal<int>`.

## Guidelines

- Style the list with `ContactListView` builders first. Those parameters use the `*Builder` suffix (`indexBarBoxDecorationBuilder`, `indexBarTextStyleBuilder`).
- Standalone `ContactIndexBar` uses different field names for the same typedefs: `indexBarBoxDecoration` and `indexBarTextStyle`. Do not pass `indexBarBoxDecorationBuilder` to `ContactIndexBar`.
- `ContactIndexBar.selectedIndex` is `FlutterSignal<int>`, not `int`. Create it with `signal<int>(-1)` from `package:signals_flutter/signals_flutter.dart`. The bar does not dispose that signal.
- `ContactIndexBar.parentKey` must be a `GlobalKey` on an ancestor used for `localToGlobal`. Cursor offsets are relative to that ancestor.
- `ContactCursor` must sit in a `Stack`. When `cursorInfo` is `null` it builds `SizedBox.shrink()` (hidden).
- `cursorContainerSize` still drives `top = offset.dy - cursorContainerSize / 2` when `cursorBuilder` is set.
- A non-null `ContactListView.stickyHeaderBuilder` replaces `ContactStickyHeader` entirely. Header height, padding, decoration, text style, alignment, and header animation on `ContactListView` then have no effect.
- After 2.0.0, standalone widgets take `ColorScheme` and `TextTheme` from `material_ui` (`Theme.of(context).colorScheme` / `.textTheme`).
- Do not import `lib/package/flutter_sticky_header/`.

## Builder typedefs (pass these to ContactListView)

| Typedef                                   | Signature                                    | ContactListView field              |
| ----------------------------------------- | -------------------------------------------- | ---------------------------------- |
| `ContactListItemBuilder<T>`               | `Widget Function(T model)`                   | `itemBuilder`                      |
| `ContactStickyHeaderBuilder`              | `Widget Function(String tag, bool isPinned)` | `stickyHeaderBuilder`              |
| `ContactCursorBuilder`                    | `Widget Function(String title)`              | `cursorBuilder`                    |
| `ContactIndexBarBoxDecorationBuilder`     | `BoxDecoration Function(bool isSelected)`    | `indexBarBoxDecorationBuilder`     |
| `ContactIndexBarTextStyleBuilder`         | `TextStyle Function(bool isSelected)`        | `indexBarTextStyleBuilder`         |
| `ContactStickyHeaderBoxDecorationBuilder` | `BoxDecoration Function(bool isPinned)`      | `stickyHeaderBoxDecorationBuilder` |
| `ContactStickyHeaderTextStyleBuilder`     | `TextStyle Function(bool isPinned)`          | `stickyHeaderTextStyleBuilder`     |

Full notes: [typedefs](references/typedefs.md).

## Customize through ContactListView

```dart
ContactListView<String>(
  contactsList: names,
  itemExtent: 40,
  startItemExtent: 1,
  endItemExtent: 1,
  tag: (name) => name[0].toUpperCase(),
  itemBuilder: (name) => ListTile(dense: true, title: Text(name)),
  cursorBuilder: (String title) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      shape: BoxShape.circle,
    ),
    child: SizedBox.square(
      dimension: 40,
      child: Center(child: Text(title)),
    ),
  ),
  indexBarBoxDecorationBuilder: (bool isSelected) => BoxDecoration(
    shape: BoxShape.circle,
    color: isSelected ? Theme.of(context).colorScheme.primary : null,
  ),
  indexBarTextStyleBuilder: (bool isSelected) => TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.bold,
    color: isSelected ? Theme.of(context).colorScheme.onPrimary : null,
  ),
  stickyHeaderBuilder: (String tag, bool isPinned) => Container(
    height: 32,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 16),
    color: Theme.of(context).colorScheme.surface,
    child: Text(tag),
  ),
)
```

## Member references

- [ContactIndexBar](references/contact-index-bar.md)
- [ContactCursor](references/contact-cursor.md)
- [ContactStickyHeader](references/contact-sticky-header.md)
- [ContactListCursorInfoModel](references/contact-list-cursor-info-model.md)
- [typedefs](references/typedefs.md)
