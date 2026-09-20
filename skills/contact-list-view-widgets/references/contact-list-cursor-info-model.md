# ContactListCursorInfoModel

- Import: `package:contact_list_view/contact_list_view.dart`
- Kind: public data class (no methods, no `copyWith`, no `==` override)
- Role: payload for `ContactCursor.cursorInfo`. `ContactListView` allocates this while the index bar is active and sets it to `null` on selection end.

`Offset` is the Flutter geometry type (`package:flutter/animation.dart` is what this file imports; app code can use `Offset` from `material_ui` / `dart:ui`).

## Constructor

```dart
ContactListCursorInfoModel({
  required this.title,
  required this.offset,
});
```

Both arguments are required. Not a `const` constructor.

## Public fields

**`title`** — `final String`.
Letter shown in the cursor (the section tag / index symbol).

**`offset`** — `final Offset`.
Position of the active index letter. `ContactIndexBar` sets `dx` to the letter cell's left in `parentKey` space and `dy` to the cell's vertical center. `ContactCursor` uses `offset.dy` only (`top = offset.dy - cursorContainerSize / 2`) and ignores `offset.dx` for placement (`right` comes from `cursorPositionedRight`).

## Public methods

None.

## APIs this class does not have

- `visible`
- `copyWith`
- Size / color fields (those live on `ContactCursor`)

## Example

```dart
final ContactListCursorInfoModel info = ContactListCursorInfoModel(
  title: 'C',
  offset: const Offset(0, 96),
);
```
