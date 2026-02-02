/// 联系人列表的数据对象 / Contact list data model.
///
/// [tag] 是标签，比如 A、Z / [tag] is the section label (e.g. A, Z).
/// [contacts] 是属于 [tag] 的集合 / [contacts] belongs to the [tag] section.
class ContactListModel<T> {
  /// 分组标签 / Section tag.
  final String tag;

  /// 分组内联系人 / Contacts in the section.
  final List<T> contacts;

  ContactListModel({required this.tag, required this.contacts});
}
