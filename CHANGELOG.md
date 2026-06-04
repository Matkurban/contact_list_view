## 1.3.1

- update signals_flutter to 7.1.0 and scrollview_observer to 1.27.0, upgrade signals_lint to 7.1.0

## 1.3.0

- apply code formatting and update signals_flutter to 7.0.0 with signals_lint integration

## 1.2.0

- migrate to signals_flutter package and update ContactListView with scrollCacheExtent and keyboardDismissBehavior support

## 1.1.1

- Fix section jump failures on index drag by using `SliverList`-level contexts instead of list item contexts
- Fix index highlight sync mismatch in viewport observation by aligning section context tracking
- Fix index cursor vertical offset calculation (`height` instead of `width`)

## 1.1.0

- Remove `showStickyHeader` properties
- Fix the abnormal alphabetic index problem when `sticky` is `false`

## 1.0.0

- Initial release with sticky headers and index bar / 初始版本，支持粘性分组头与字母索引条
