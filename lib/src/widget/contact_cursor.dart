import 'package:contact_list_view/contact_list_view.dart';
import 'package:flutter/material.dart';

class ContactCursor extends StatelessWidget {
  const ContactCursor({
    super.key,
    required this.cursorInfo,
    required this.cursorContainerSize,
    required this.cursorPositionedRight,
    this.cursorBuilder,
    required this.cursorAnimatedPositionedDuration,
    required this.textTheme,
    required this.colorScheme,
  });

  /// 游标数据（为 null 时隐藏游标） / Cursor info (hidden when null).
  final ContactListCursorInfoModel? cursorInfo;

  /// 游标容器尺寸 / Cursor container size.
  final double cursorContainerSize;

  /// 游标右侧偏移 / Right offset for cursor.
  final double cursorPositionedRight;

  /// 自定义游标构建器 / Custom cursor builder.
  final ContactCursorBuilder? cursorBuilder;

  /// 游标动画时长 / Cursor animation duration.
  final Duration cursorAnimatedPositionedDuration;

  /// 文本主题 / Text theme.
  final TextTheme textTheme;

  /// 颜色方案 / Color scheme.
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    if (cursorInfo == null) return SizedBox.shrink();
    return AnimatedPositioned(
      top: cursorInfo!.offset.dy - cursorContainerSize / 2,
      right: cursorPositionedRight,
      duration: cursorAnimatedPositionedDuration,
      child:
          cursorBuilder?.call(cursorInfo!.title) ??
          Container(
            width: cursorContainerSize,
            height: cursorContainerSize,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              cursorInfo!.title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
    );
  }
}
