# Public typedefs

Import: `package:contact_list_view/contact_list_view.dart`  
Defined in `lib/src/define/define_type.dart`. These are function types only; they have no methods.

## ContactListItemBuilder\<T\>

```dart
typedef ContactListItemBuilder<T> = Widget Function(T model);
```

Single contact row for `ContactListView.itemBuilder`.

| Parameter | Type | Meaning |
| --- | --- | --- |
| `model` | `T` | The contact. No `BuildContext`, no index. |

Return a widget whose height matches `ContactListView.itemExtent`.

## ContactStickyHeaderBuilder

```dart
typedef ContactStickyHeaderBuilder = Widget Function(String tag, bool isPinned);
```

Used as `ContactListView.stickyHeaderBuilder`. When non-null, the default `ContactStickyHeader` is not built.

| Parameter | Type | Meaning |
| --- | --- | --- |
| `tag` | `String` | Section key from `ContactListView.tag`. |
| `isPinned` | `bool` | Sticky-header sliver `state.isPinned`. Not AND-ed with `ContactListView.sticky`. |

Size the returned widget yourself (`ContactListView.stickyHeaderHeight` is ignored).

## ContactCursorBuilder

```dart
typedef ContactCursorBuilder = Widget Function(String title);
```

Used as `ContactListView.cursorBuilder` and `ContactCursor.cursorBuilder`.

| Parameter | Type | Meaning |
| --- | --- | --- |
| `title` | `String` | Current index letter (`ContactListCursorInfoModel.title`). |

Return the floating indicator only. Placement uses `cursorContainerSize` and `cursorPositionedRight` on the parent.

## ContactIndexBarBoxDecorationBuilder

```dart
typedef ContactIndexBarBoxDecorationBuilder = BoxDecoration Function(bool isSelected);
```

| Parameter | Type | Meaning |
| --- | --- | --- |
| `isSelected` | `bool` | Whether this letter is the current index. |

Wired as:

- `ContactListView.indexBarBoxDecorationBuilder`
- `ContactIndexBar.indexBarBoxDecoration`

Default when omitted: circular decoration, `colorScheme.primary` fill only when selected.

## ContactIndexBarTextStyleBuilder

```dart
typedef ContactIndexBarTextStyleBuilder = TextStyle Function(bool isSelected);
```

| Parameter | Type | Meaning |
| --- | --- | --- |
| `isSelected` | `bool` | Whether this letter is the current index. |

Wired as:

- `ContactListView.indexBarTextStyleBuilder`
- `ContactIndexBar.indexBarTextStyle`

Default when omitted: `fontSize: 9`, `FontWeight.bold`, `colorScheme.onPrimary` when selected, otherwise `color: null`.

## ContactStickyHeaderBoxDecorationBuilder

```dart
typedef ContactStickyHeaderBoxDecorationBuilder = BoxDecoration Function(bool isPinned);
```

| Parameter | Type | Meaning |
| --- | --- | --- |
| `isPinned` | `bool` | Header pin state passed into `ContactStickyHeader`. |

Wired as `ContactListView.stickyHeaderBoxDecorationBuilder` and `ContactStickyHeader.stickyHeaderBoxDecorationBuilder`. Has no effect on `ContactListView` when `stickyHeaderBuilder` is set.

Default when omitted (inside `ContactStickyHeader`): `colorScheme.surface`; if pinned, bottom `Border` and `BoxShadow` using `colorScheme.surfaceContainerHighest` (`blurRadius: 16`).

## ContactStickyHeaderTextStyleBuilder

```dart
typedef ContactStickyHeaderTextStyleBuilder = TextStyle Function(bool isPinned);
```

| Parameter | Type | Meaning |
| --- | --- | --- |
| `isPinned` | `bool` | Header pin state passed into `ContactStickyHeader`. |

Wired as `ContactListView.stickyHeaderTextStyleBuilder` and `ContactStickyHeader.stickyHeaderTextStyleBuilder`. Has no effect on `ContactListView` when `stickyHeaderBuilder` is set.

Default when omitted: `textTheme.bodySmall` with `FontWeight.w600`.
