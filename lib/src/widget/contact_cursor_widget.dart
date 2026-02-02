import 'package:contact_list_view/contact_list_view.dart';
import 'package:flutter/material.dart';

/// 通用字母游标组件
///
/// 当用户滑动字母索引栏时，显示当前选中的字母
class ContactCursorWidget extends StatelessWidget {
  const ContactCursorWidget({
    super.key,
    required this.cursorInfo,
    required this.cursorContainerSize,
    required this.cursorPositionedRight,
    this.cursorBuilder,
    required this.textTheme,
    required this.colorScheme,
  });

  /// 游标数据（为 null 时隐藏游标）
  final ContactListCursorInfoModel? cursorInfo;

  final double cursorContainerSize;

  final double cursorPositionedRight;

  final CursorBuilder? cursorBuilder;

  final TextTheme textTheme;

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: cursorInfo != null,
      child: AnimatedPositioned(
        top: cursorInfo!.offset.dy - cursorContainerSize / 2,
        right: cursorPositionedRight,
        duration: const Duration(milliseconds: 100),
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
                style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
              ),
            ),
      ),
    );
  }
}
