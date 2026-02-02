import 'package:flutter/material.dart';

/// 单个联系人构建器 / Single contact item builder.
typedef ContactListItemBuilder<T> = Widget Function(T model);

/// 头部自定义 / Sticky header builder.
typedef ContactStickyHeaderBuilder = Widget Function(String tag, bool isPinned);

/// 浮标自定义 / Cursor builder.
typedef ContactCursorBuilder = Widget Function(String title);

/// 字母索引项背景 / Index bar item decoration builder.
typedef ContactIndexBarBoxDecorationBuilder =
    BoxDecoration Function(bool isSelected);

/// 字母索引项文字样式 / Index bar item text style builder.
typedef ContactIndexBarTextStyleBuilder = TextStyle Function(bool isSelected);

/// 悬浮头部背景 / Sticky header decoration builder.
typedef ContactStickyHeaderBoxDecorationBuilder =
    BoxDecoration Function(bool isPinned);

/// 悬浮头部文字样式 / Sticky header text style builder.
typedef ContactStickyHeaderTextStyleBuilder = TextStyle Function(bool isPinned);
