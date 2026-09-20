# ContactIndexBar

- Import: `package:contact_list_view/contact_list_view.dart`
- Kind: public `StatefulWidget`
- Role: A–Z rail. `ContactListView` already builds one. Construct this only for a custom shell.

`ColorScheme` is from `material_ui`. `FlutterSignal` is from `signals_flutter`.

## Constructor

```dart
const ContactIndexBar({
  super.key,
  required this.parentKey,
  required this.symbols,
  required this.selectedIndex,
  this.onSelectionUpdate,
  this.onSelectionEnd,
  required this.indexBarSize,
  this.indexBarBoxDecoration,
  this.indexBarTextStyle,
  this.indexBarItemAlignment,
  required this.indexBarAnimatedContainerDuration,
  required this.colorScheme,
});
```

Required: `parentKey`, `symbols`, `selectedIndex`, `indexBarSize`, `indexBarAnimatedContainerDuration`, `colorScheme`.

There is no `indexBarAlignment` on this widget (that field exists only on `ContactListView`, on the rail `Container`). There is no `indexBarBoxDecorationBuilder` parameter name here.

## Public fields

**`parentKey`** — `GlobalKey` (required).
Ancestor whose render object is the `localToGlobal` ancestor. `onSelectionUpdate` offsets are relative to this ancestor's top-left. Attach this key to that ancestor.

**`symbols`** — `List<String>` (required).
Letters, one cell each, in list order. If `symbols.length` changes, internal selected-state computations are rebuilt in `didUpdateWidget`.

**`selectedIndex`** — `FlutterSignal<int>` (required).
Current selected letter index. Not an `int`. The bar reads `.value` (via `computed`) to highlight a cell. It does not write this signal; `ContactListView` writes it. Caller owns creation and disposal. Typical idle value in `ContactListView` is `-1`.

```dart
import 'package:signals_flutter/signals_flutter.dart';

final FlutterSignal<int> selectedIndex = signal<int>(-1);
```

**`onSelectionUpdate`** — `void Function(int index, Offset cursorOffset)?`.
Fired from tap-up, vertical-drag-down, and vertical-drag-update after a one-shot list observe. `index` is the observed letter's index in `symbols`. `cursorOffset` is the letter cell's top-left in `parentKey` space, plus half the cell height on `dy` (vertical center). If observe yields no child, the callback is not invoked.

**`onSelectionEnd`** — `VoidCallback?`.
Fired on vertical-drag-end and vertical-drag-cancel. `ContactListView` uses this to clear cursor info (hide `ContactCursor`).

**`indexBarSize`** — `double` (required).
Width and height of each letter `AnimatedContainer`.

**`indexBarBoxDecoration`** — `ContactIndexBarBoxDecorationBuilder?`.
`BoxDecoration Function(bool isSelected)`. Default: `BoxDecoration(shape: BoxShape.circle, color: isSelected ? colorScheme.primary : null)`.

**`indexBarTextStyle`** — `ContactIndexBarTextStyleBuilder?`.
`TextStyle Function(bool isSelected)`. Default: `fontSize: 9`, `fontWeight: FontWeight.bold`, `color: isSelected ? colorScheme.onPrimary : null`.

**`indexBarItemAlignment`** — `Alignment?`.
Glyph alignment in the cell. `Alignment.center` when null.

**`indexBarAnimatedContainerDuration`** — `Duration` (required).
`AnimatedContainer.duration` per letter. `ContactListView` defaults this to `Duration(milliseconds: 0)`.

**`colorScheme`** — `ColorScheme` (required, `material_ui`).
Used by the default decoration and text color.

## Public methods

### `createState`

```dart
@override
State<ContactIndexBar> createState() => _ContactIndexBarState();
```

Framework method. State is private. Gesture handlers (`_onGestureHandler`, `_onGestureEnd`) are not public.

## Behavior notes

- Inner `ListView` uses `NeverScrollableScrollPhysics` and `shrinkWrap: true`. The rail does not scroll on its own.
- Gestures: `onTapUp`, `onVerticalDragDown`, `onVerticalDragUpdate` → selection; `onVerticalDragEnd`, `onVerticalDragCancel` → `onSelectionEnd`.
- Hit-test behavior is `HitTestBehavior.opaque`.

## APIs this class does not have

- `indexBarBoxDecorationBuilder` / `indexBarTextStyleBuilder` (those names are on `ContactListView`)
- `indexBarAlignment` (list-level rail alignment only)
- `selectedIndex` as `int` or `ValueNotifier<int>`
- `scrollController` constructor argument
- Public `jumpTo` / `select(int)`

## Example

```dart
final GlobalKey railKey = GlobalKey();
final FlutterSignal<int> selectedIndex = signal<int>(-1);

Container(
  key: railKey,
  width: 16,
  alignment: Alignment.center,
  child: ContactIndexBar(
    parentKey: railKey,
    symbols: const ['A', 'B', '#'],
    selectedIndex: selectedIndex,
    indexBarSize: 16,
    indexBarAnimatedContainerDuration: Duration.zero,
    colorScheme: Theme.of(context).colorScheme,
    onSelectionUpdate: (int index, Offset cursorOffset) {
      selectedIndex.value = index;
    },
    onSelectionEnd: () {},
  ),
)
```
