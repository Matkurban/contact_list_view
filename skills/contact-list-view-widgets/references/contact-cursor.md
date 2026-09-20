# ContactCursor

- Import: `package:contact_list_view/contact_list_view.dart`
- Kind: public `StatelessWidget`
- Role: floating letter shown while the index bar is dragged. `ContactListView` places this in its `Stack`. Must be a descendant of a `Stack` because it builds `AnimatedPositioned`.

`TextTheme` and `ColorScheme` are from `material_ui`.

## Constructor

```dart
const ContactCursor({
  super.key,
  required this.cursorInfo,
  required this.cursorContainerSize,
  required this.cursorPositionedRight,
  this.cursorBuilder,
  required this.cursorAnimatedPositionedDuration,
  required this.textTheme,
  required this.colorScheme,
});
```

Required: `cursorInfo`, `cursorContainerSize`, `cursorPositionedRight`, `cursorAnimatedPositionedDuration`, `textTheme`, `colorScheme`.

## Public fields

**`cursorInfo`** — `ContactListCursorInfoModel?` (required, nullable).
`null` hides the cursor. Non-null `title` is the letter; `offset.dy` is the vertical center of the active index cell (in the stack/parent space used by `ContactListView`).

**`cursorContainerSize`** — `double` (required).
Default cursor width and height. Vertical position is always `cursorInfo.offset.dy - cursorContainerSize / 2`, including when `cursorBuilder` is set.

**`cursorPositionedRight`** — `double` (required).
`AnimatedPositioned.right`.

**`cursorBuilder`** — `ContactCursorBuilder?` = `Widget Function(String title)`.
When non-null, called with `cursorInfo.title` and used as the positioned child. When null, a `Container` of `cursorContainerSize` × `cursorContainerSize`, `colorScheme.primary`, `BorderRadius.circular(8)`, centered `Text` with `textTheme.titleMedium` colored `colorScheme.onPrimary`.

**`cursorAnimatedPositionedDuration`** — `Duration` (required).
`AnimatedPositioned.duration`. `ContactListView` defaults this to `Duration(milliseconds: 0)`.

**`textTheme`** — `TextTheme` (required).
Used only by the default `Text` style.

**`colorScheme`** — `ColorScheme` (required).
Used only by the default box fill and text color.

## Public methods

### `build`

```dart
@override
Widget build(BuildContext context)
```

- If `cursorInfo == null`, returns `SizedBox.shrink()`.
- Otherwise returns `AnimatedPositioned(top: offset.dy - cursorContainerSize / 2, right: cursorPositionedRight, duration: cursorAnimatedPositionedDuration, child: ...)`.

No other public methods.

## APIs this class does not have

- `visible` / `showCursor` flags (visibility is `cursorInfo == null`)
- Horizontal `left` / `top` constructor overrides beyond the fields above
- A `BuildContext` or `Offset` argument on `cursorBuilder`

## Example

```dart
Stack(
  children: [
    ContactCursor(
      cursorInfo: ContactListCursorInfoModel(
        title: 'A',
        offset: const Offset(0, 120),
      ),
      cursorContainerSize: 40,
      cursorPositionedRight: 32,
      cursorAnimatedPositionedDuration: Duration.zero,
      textTheme: Theme.of(context).textTheme,
      colorScheme: Theme.of(context).colorScheme,
    ),
  ],
)
```
