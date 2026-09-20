# ContactListView\<T\>

- Import: `package:contact_list_view/contact_list_view.dart`
- Kind: public `SignalStatefulWidget` (from `signals_flutter`). App code constructs it; do not subclass it.
- Role: the only widget most apps need. It groups `contactsList` by `tag`, builds one sticky section per group, draws the index bar and cursor, and hosts optional start/end children.

## Constructor

```dart
const ContactListView({
  super.key,
  required this.contactsList,
  required this.itemExtent,
  this.startChildren = const <Widget>[],
  required this.startItemExtent,
  this.endChildren = const <Widget>[],
  required this.endItemExtent,
  required this.tag,
  required this.itemBuilder,
  this.sticky = true,
  this.stickyHeaderHeight = 32,
  this.stickyHeaderBuilder,
  this.cursorContainerSize = 40,
  this.cursorPositionedRight = 32,
  this.cursorBuilder,
  this.indexBarPositionedRight = 4,
  this.indexBarSize = 16,
  this.indexBarBoxDecorationBuilder,
  this.indexBarTextStyleBuilder,
  this.indexBarAlignment,
  this.indexBarItemAlignment,
  this.cursorAnimatedPositionedDuration = const Duration(milliseconds: 0),
  this.indexBarAnimatedContainerDuration = const Duration(milliseconds: 0),
  this.stickyHeaderAnimatedContainerDuration = const Duration(milliseconds: 0),
  this.stickyHeaderPadding,
  this.stickyHeaderBoxDecorationBuilder,
  this.stickyHeaderTextStyleBuilder,
  this.stickyHeaderAlignment,
  this.scrollCacheExtent,
  this.keyboardDismissBehavior,
});
```

Required: `contactsList`, `itemExtent`, `startItemExtent`, `endItemExtent`, `tag`, `itemBuilder`.

## Public fields

### Data and rows

**`contactsList`** — `List<T>` (required).
Source items. Each item is passed through `tag` then `itemBuilder`. Empty list yields no sections and an empty index bar; `startChildren` / `endChildren` still render.

**`tag`** — `String Function(T model)` (required).
Section key. Same string → same section. The widget never normalizes case, pinyin, or `#` itself. A section is sorted to the end only when this function returns the exact string `'#'`.

**`itemBuilder`** — `ContactListItemBuilder<T>` = `Widget Function(T model)` (required).
One contact row. No `BuildContext`, no index. Height must equal `itemExtent` (rows sit in `SliverFixedExtentList`).

**`itemExtent`** — `double` (required).
Forced main-axis extent of every contact row.

### Start and end children

**`startChildren`** — `List<Widget>`, default `const <Widget>[]`.
Widgets placed in a leading `SliverFixedExtentList` **before** contact sections. Not slivers.

**`startItemExtent`** — `double` (required).
Forced extent of every `startChildren` entry. Still required when the list is empty.

**`endChildren`** — `List<Widget>`, default `const <Widget>[]`.
Widgets in a trailing `SliverFixedExtentList` **after** contact sections. Not slivers.

**`endItemExtent`** — `double` (required).
Forced extent of every `endChildren` entry. Still required when the list is empty.

### Sticky headers

**`sticky`** — `bool`, default `true`.
Forwarded to the internal sticky-header sliver. When `false`, section headers do not pin. The default `ContactStickyHeader` receives `isPinned: state.isPinned && sticky`.

**`stickyHeaderHeight`** — `double`, default `32`.
Height of the **default** `ContactStickyHeader`. Ignored when `stickyHeaderBuilder` is non-null (the builder owns height).

**`stickyHeaderBuilder`** — `ContactStickyHeaderBuilder?` = `Widget Function(String tag, bool isPinned)`.
When non-null, this widget is used instead of `ContactStickyHeader`. Arguments are the section `tag` and `state.isPinned` (not AND-ed with `sticky`). While this is set, these fields do not style the header: `stickyHeaderHeight`, `stickyHeaderPadding`, `stickyHeaderBoxDecorationBuilder`, `stickyHeaderTextStyleBuilder`, `stickyHeaderAlignment`, `stickyHeaderAnimatedContainerDuration`.

**`stickyHeaderPadding`** — `EdgeInsets?`, default `null`.
Default header uses `EdgeInsets.only(left: 16)` when null. Ignored if `stickyHeaderBuilder` is set.

**`stickyHeaderBoxDecorationBuilder`** — `ContactStickyHeaderBoxDecorationBuilder?` = `BoxDecoration Function(bool isPinned)`.
Default header decoration. Ignored if `stickyHeaderBuilder` is set. When null, default header uses `colorScheme.surface`, and when pinned a bottom `Border` plus `BoxShadow` in `colorScheme.surfaceContainerHighest`.

**`stickyHeaderTextStyleBuilder`** — `ContactStickyHeaderTextStyleBuilder?` = `TextStyle Function(bool isPinned)`.
Default header text style. Ignored if `stickyHeaderBuilder` is set. When null, default is `textTheme.bodySmall` with `FontWeight.w600`.

**`stickyHeaderAlignment`** — `Alignment?`, default `null`.
Default header alignment, `Alignment.centerLeft` when null. Ignored if `stickyHeaderBuilder` is set.

**`stickyHeaderAnimatedContainerDuration`** — `Duration`, default `Duration(milliseconds: 0)`.
`AnimatedContainer` duration of the default header. Ignored if `stickyHeaderBuilder` is set.

### Cursor

**`cursorContainerSize`** — `double`, default `40`.
Default cursor box width and height. Also used for vertical placement: `top = cursorOffset.dy - cursorContainerSize / 2`, even when `cursorBuilder` is set.

**`cursorPositionedRight`** — `double`, default `32`.
`right` of the cursor `AnimatedPositioned`.

**`cursorBuilder`** — `ContactCursorBuilder?` = `Widget Function(String title)`.
When non-null, replaces the default rounded `Container` + `Text`. The builder does not receive size; size the returned widget yourself. Positioning still uses `cursorContainerSize` and `cursorPositionedRight`.

**`cursorAnimatedPositionedDuration`** — `Duration`, default `Duration(milliseconds: 0)`.
`AnimatedPositioned.duration` for the cursor.

### Index bar

**`indexBarPositionedRight`** — `double`, default `4`.
`right` of the index-bar `Positioned` (full height: `top: 0`, `bottom: 0`).

**`indexBarSize`** — `double`, default `16`.
Width of the index-bar column and width/height of each letter cell.

**`indexBarBoxDecorationBuilder`** — `ContactIndexBarBoxDecorationBuilder?` = `BoxDecoration Function(bool isSelected)`.
Per-letter decoration. Parameter name on `ContactListView` is `indexBarBoxDecorationBuilder`. On standalone `ContactIndexBar` the same typedef is the field `indexBarBoxDecoration`. When null: `BoxDecoration(shape: BoxShape.circle, color: isSelected ? colorScheme.primary : null)`.

**`indexBarTextStyleBuilder`** — `ContactIndexBarTextStyleBuilder?` = `TextStyle Function(bool isSelected)`.
Per-letter text style. On standalone `ContactIndexBar` the field is `indexBarTextStyle`. When null: `fontSize: 9`, `fontWeight: FontWeight.bold`, `color: isSelected ? colorScheme.onPrimary : null`.

**`indexBarAlignment`** — `Alignment?`, default `null`.
Alignment of the letter column inside the full-height rail. `Alignment.center` when null.

**`indexBarItemAlignment`** — `Alignment?`, default `null`.
Alignment of the glyph inside each `indexBarSize` × `indexBarSize` cell. `Alignment.center` when null.

**`indexBarAnimatedContainerDuration`** — `Duration`, default `Duration(milliseconds: 0)`.
`AnimatedContainer` duration for each index letter.

### Scroll view

**`scrollCacheExtent`** — `ScrollCacheExtent?`, default `null`.
Forwarded to the inner `CustomScrollView.scrollCacheExtent` (`flutter/rendering.dart`).

**`keyboardDismissBehavior`** — `ScrollViewKeyboardDismissBehavior?`, default `null`.
Forwarded to the inner `CustomScrollView`. When null, Flutter falls back to `ScrollBehavior.getKeyboardDismissBehavior`.

## Public methods

### `createState`

```dart
@override
State<ContactListView<T>> createState() => _ContactListViewState<T>();
```

Framework method. The state class is private. There are no other public methods (`jumpTo`, `scrollToIndex`, `animateTo`, accessors for `ScrollController` do not exist).

## Grouping (implementation)

1. Walk `contactsList` in order. `tag(item)` is the map key. First time a key appears, a new list is created; later items with that key are appended.
2. Each group's list is sorted with `tag(a).compareTo(tag(b))`. In a group all tags are equal, so this does not reorder by name.
3. Groups are sorted: if `a.tag == '#'` then `a` is after `b`; if `b.tag == '#'` then `a` is before `b`; otherwise `a.tag.compareTo(b.tag)`.
4. Index-bar symbols are those section tags in that sorted order.

`#` is not assigned automatically. Digits, CJK, and empty names stay in whatever string `tag` returns.

## Defaults used internally (not constructor parameters)

`ContactListView` reads `Theme.of(context)` and passes `colorScheme` / `textTheme` into the default cursor, index bar, and header. App code does not pass those on `ContactListView`.

Index-bar selection starts at `-1` (no letter selected) until a section is observed or the user drags the bar.

## APIs this class does not have

- `controller` / `ScrollController`
- `jumpTo`, `scrollToIndex`, `animateTo`
- `showStickyHeader`
- `startSlivers`, `endSlivers`
- `onIndexChanged` / `onSelectionUpdate` (those exist on `ContactIndexBar`, not here)
- Name comparator or `sortBy`

## Example (required fields only)

```dart
ContactListView<String>(
  contactsList: const ['Ann', 'Ben', 'Zoe'],
  itemExtent: 40,
  startItemExtent: 1,
  endItemExtent: 1,
  tag: (name) => name[0].toUpperCase(),
  itemBuilder: (name) => Text(name),
)
```
