import 'package:flutter/material.dart';

///单个联系人
typedef ContactListItemBuilder<T> = Widget Function(T model);

///头部自定义
typedef ContactStickyHeaderBuilder = Widget Function(String tag, bool isPinned);

///浮标自定义
typedef ContactCursorBuilder = Widget Function(String title);

typedef ContactIndexBarBoxDecorationBuilder = BoxDecoration Function(bool isSelected);

typedef ContactIndexBarTextStyleBuilder = TextStyle Function(bool isSelected);

typedef ContactStickyHeaderBoxDecorationBuilder = BoxDecoration Function(bool isPinned);

typedef ContactStickyHeaderTextStyleBuilder = TextStyle Function(bool isPinned);
