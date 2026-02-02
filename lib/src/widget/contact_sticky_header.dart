import 'package:flutter/material.dart';

import '../define/define_type.dart';

class ContactStickyHeader extends StatelessWidget {
  const ContactStickyHeader({
    super.key,
    required this.tag,
    required this.isPinned,
    required this.sticky,
    required this.stickyHeaderHeight,
    required this.stickyHeaderAnimatedContainerDuration,
    this.stickyHeaderPadding,
    this.stickyHeaderBoxDecorationBuilder,
    this.stickyHeaderTextStyleBuilder,
    this.stickyHeaderAlignment,
    required this.colorScheme,
    required this.textTheme,
  });

  /// 分组字母 / Section tag.
  final String tag;

  /// 是否处于固定状态 / Whether the header is pinned.
  final bool isPinned;

  /// 是否启用粘性 / Whether sticky is enabled.
  final bool sticky;

  /// 头部高度 / Header height.
  final double stickyHeaderHeight;

  /// 头部动画时长 / Header animation duration.
  final Duration stickyHeaderAnimatedContainerDuration;

  /// 头部内边距 / Header padding.
  final EdgeInsets? stickyHeaderPadding;

  /// 头部背景构建器 / Header decoration builder.
  final ContactStickyHeaderBoxDecorationBuilder?
  stickyHeaderBoxDecorationBuilder;

  /// 头部文字样式 / Header text style builder.
  final ContactStickyHeaderTextStyleBuilder? stickyHeaderTextStyleBuilder;

  /// 头部对齐 / Header alignment.
  final Alignment? stickyHeaderAlignment;

  /// 颜色方案 / Color scheme.
  final ColorScheme colorScheme;

  /// 文本主题 / Text theme.
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    if (isPinned && !sticky) {
      return SizedBox(height: stickyHeaderHeight);
    }
    return AnimatedContainer(
      height: stickyHeaderHeight,
      duration: stickyHeaderAnimatedContainerDuration,
      padding: stickyHeaderPadding ?? EdgeInsets.only(left: 16),
      alignment: stickyHeaderAlignment ?? Alignment.centerLeft,
      decoration:
          stickyHeaderBoxDecorationBuilder?.call(isPinned) ??
          BoxDecoration(
            color: colorScheme.surface,
            border: isPinned
                ? Border(
                    bottom: BorderSide(
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  )
                : null,
            boxShadow: [
              if (isPinned)
                BoxShadow(
                  color: colorScheme.surfaceContainerHighest,
                  blurRadius: 16,
                ),
            ],
          ),
      child: Text(
        tag,
        style:
            stickyHeaderTextStyleBuilder?.call(isPinned) ??
            textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
