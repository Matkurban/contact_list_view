import 'package:flutter/animation.dart';

/// 游标的数据模型 / Cursor data model.
class ContactListCursorInfoModel {
  /// 字母 / Letter.
  final String title;

  /// 字母中心点的偏移量 / Center offset of the letter.
  final Offset offset;

  ContactListCursorInfoModel({required this.title, required this.offset});
}
