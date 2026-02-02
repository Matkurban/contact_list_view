import 'package:flutter/animation.dart';

/// 游标的数据模型
class ContactListCursorInfoModel {
  /// 字母
  final String title;

  /// 字母中心点的偏移量
  final Offset offset;

  ContactListCursorInfoModel({required this.title, required this.offset});
}
