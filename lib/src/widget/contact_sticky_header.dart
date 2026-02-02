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

  /// 分组字母
  final String tag;

  /// 是否处于固定状态
  final bool isPinned;

  final bool sticky;

  final double stickyHeaderHeight;

  final Duration stickyHeaderAnimatedContainerDuration;

  final EdgeInsets? stickyHeaderPadding;

  final ContactStickyHeaderBoxDecorationBuilder? stickyHeaderBoxDecorationBuilder;

  final ContactStickyHeaderTextStyleBuilder? stickyHeaderTextStyleBuilder;

  final Alignment? stickyHeaderAlignment;

  final ColorScheme colorScheme;

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
                ? Border(bottom: BorderSide(color: colorScheme.surfaceContainerHighest))
                : null,
            boxShadow: [
              if (isPinned) BoxShadow(color: colorScheme.surfaceContainerHighest, blurRadius: 16),
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
