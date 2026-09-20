# ContactListModel\<T\>

- Import: `package:contact_list_view/contact_list_view.dart`
- Kind: public immutable data class (no methods, no `copyWith`, no `==` override)
- Role: one grouped section. `ContactListView` constructs these in `initState` and again in `didUpdateWidget`. App code almost never allocates this type; it is exported so the grouping shape is visible.

## Constructor

```dart
ContactListModel({
  required this.tag,
  required this.contacts,
});
```

Both arguments are required. Not a `const` constructor.

## Public fields

**`tag`** — `final String`.
Section label shown on the sticky header and on the matching index-bar letter (for example `"A"` or `"#"`).

**`contacts`** — `final List<T>`.
Items that returned this `tag` from `ContactListView.tag`, in `contactsList` insertion order.

## Public methods

None. There is no `toJson`, `copyWith`, `compareTo`, or grouping helper on this type.

## APIs this class does not have

- Factory from a flat list
- Sorting helpers
- Mutation methods (`contacts` is a `List` field; `ContactListView` does not expose the instances it creates)

## Example

```dart
final ContactListModel<String> section = ContactListModel<String>(
  tag: 'A',
  contacts: <String>['Ann', 'Amy'],
);
```

Prefer letting `ContactListView` build sections from `contactsList` + `tag` instead of assembling `ContactListModel` yourself.
