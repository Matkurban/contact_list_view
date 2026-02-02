import 'package:flutter/material.dart';

///单个联系人
typedef ContactListItemBuilder<T> = Widget Function(T model);

///头部自定义
typedef ContactSectionHeaderBuilder = Widget Function(String tag, bool isPinned);

///浮标自定义
typedef CursorBuilder = Widget Function(String title);
