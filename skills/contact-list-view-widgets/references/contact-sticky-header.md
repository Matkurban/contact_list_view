# ContactStickyHeader

- Import: `package:contact_list_view/contact_list_view.dart`
- Kind: public `StatelessWidget`
- Role: default section header. `ContactListView` builds this when `stickyHeaderBuilder` is null. You can instantiate it inside a custom `stickyHeaderBuilder` if you want the default look with extra wrapping.

`ColorScheme` and `TextTheme` are from `material_ui`.

## Constructor

```dart
const ContactStickyHeader({
  super.key,
  required this.tag,
  required this.isPinned,
  required this.stickyHeaderHeight,
  required this.stickyHeaderAnimatedContainerDuration,
  this.stickyHeaderPadding,
  this.stickyHeaderBoxDecorationBuilder,
  this.stickyHeaderTextStyleBuilder,
  this.stickyHeaderAlignment,
  required this.colorScheme,
  required this.textTheme,
});
```

Required: `tag`, `isPinned`, `stickyHeaderHeight`, `stickyHeaderAnimatedContainerDuration`, `colorScheme`, `textTheme`.

## Public fields

**`tag`** — `String` (required).
Section label drawn as the header `Text`.

**`isPinned`** — `bool` (required).
Passed into the decoration and text-style builders. `ContactListView` sets this to `state.isPinned && widget.sticky` for the default header.

**`stickyHeaderHeight`** — `double` (required).
`AnimatedContainer.height`. `ContactListView` defaults this to `32`.

**`stickyHeaderAnimatedContainerDuration`** — `Duration` (required).
`AnimatedContainer.duration`. `ContactListView` defaults this to `Duration(milliseconds: 0)`.

**`stickyHeaderPadding`** — `EdgeInsets?`.
`AnimatedContainer.padding`. When null: `EdgeInsets.only(left: 16)`.

**`stickyHeaderBoxDecorationBuilder`** — `ContactStickyHeaderBoxDecorationBuilder?`.
`BoxDecoration Function(bool isPinned)`. When null:

```dart
BoxDecoration(
  color: colorScheme.surface,
  border: isPinned
      ? Border(
          bottom: BorderSide(color: colorScheme.surfaceContainerHighest),
        )
      : null,
  boxShadow: [
    if (isPinned)
      BoxShadow(
        color: colorScheme.surfaceContainerHighest,
        blurRadius: 16,
      ),
  ],
)
```

**`stickyHeaderTextStyleBuilder`** — `ContactStickyHeaderTextStyleBuilder?`.
`TextStyle Function(bool isPinned)`. When null: `textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)`.

**`stickyHeaderAlignment`** — `Alignment?`.
`AnimatedContainer.alignment`. When null: `Alignment.centerLeft`.

**`colorScheme`** — `ColorScheme` (required).
Used by the default decoration.

**`textTheme`** — `TextTheme` (required).
Used by the default text style.

## Public methods

### `build`

```dart
@override
Widget build(BuildContext context)
```

Returns an `AnimatedContainer` with the height, duration, padding, alignment, and decoration above, and a `Text(tag)` child. `context` is unused beyond the `StatelessWidget` contract.

No other public methods.

## APIs this class does not have

- `stickyHeaderBuilder` (that parameter is on `ContactListView` only)
- `onPinChanged`
- Leading/trailing widget slots

## Example

```dart
final ThemeData theme = Theme.of(context);

ContactStickyHeader(
  tag: 'A',
  isPinned: true,
  stickyHeaderHeight: 32,
  stickyHeaderAnimatedContainerDuration: Duration.zero,
  colorScheme: theme.colorScheme,
  textTheme: theme.textTheme,
)
```
