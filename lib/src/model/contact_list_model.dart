///联系人列表的数据对象
///[tag]是标签；比如A，Z
///[contacts] 是属于 [tag]的集合
class ContactListModel<T> {
  final String tag;
  final List<T> contacts;

  ContactListModel({required this.tag, required this.contacts});
}
