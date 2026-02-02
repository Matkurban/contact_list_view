import 'package:flutter/material.dart';

/// 通用字母分组标题组件
///
/// 用于显示字母分组的 sticky header
class ContactListSectionHeader extends StatelessWidget {
  const ContactListSectionHeader({
    super.key,
    required this.tag,
    required this.isPinned,
    required this.colorScheme,
    required this.textTheme,
  });

  /// 分组字母
  final String tag;

  /// 是否处于固定状态
  final bool isPinned;

  final ColorScheme colorScheme;

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: isPinned
            ? Border(bottom: BorderSide(color: colorScheme.surfaceContainerHighest))
            : null,
        boxShadow: [
          if (isPinned) BoxShadow(color: colorScheme.surfaceContainerHighest, blurRadius: 16),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: Text(tag, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
