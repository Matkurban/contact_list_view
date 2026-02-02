import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../define/define_type.dart';

class ContactIndexBar extends StatefulWidget {
  const ContactIndexBar({
    super.key,
    required this.parentKey,
    required this.symbols,
    required this.selectedIndex,
    this.onSelectionUpdate,
    this.onSelectionEnd,
    required this.indexBarSize,
    this.indexBarBoxDecoration,
    this.indexBarTextStyle,
    this.indexBarItemAlignment,
    required this.indexBarAnimatedContainerDuration,
    required this.colorScheme,
  });

  /// 父容器的 Key，用于计算游标相对位置 / Parent key for cursor positioning.
  final GlobalKey parentKey;

  /// 字母列表 / Index symbols.
  final List<String> symbols;

  /// 当前选中的字母索引 / Selected index.
  final int selectedIndex;

  /// 选中字母变化时的回调 / Selection update callback.
  final void Function(int index, Offset cursorOffset)? onSelectionUpdate;

  /// 选择结束时的回调 / Selection end callback.
  final VoidCallback? onSelectionEnd;

  /// 索引条尺寸 / Index bar item size.
  final double indexBarSize;

  /// 索引条背景构建器 / Index bar decoration builder.
  final ContactIndexBarBoxDecorationBuilder? indexBarBoxDecoration;

  /// 索引条文字样式 / Index bar text style builder.
  final ContactIndexBarTextStyleBuilder? indexBarTextStyle;

  /// 索引条对齐 / Index bar item alignment.
  final Alignment? indexBarItemAlignment;

  /// 选中动画时长 / Selection animation duration.
  final Duration indexBarAnimatedContainerDuration;

  /// 颜色方案 / Color scheme.
  final ColorScheme colorScheme;

  @override
  State<ContactIndexBar> createState() => _ContactIndexBarState();
}

class _ContactIndexBarState extends State<ContactIndexBar> {
  /// 内部滚动控制器 / Internal scroll controller.
  late final ScrollController scrollController;

  /// 观察控制器 / Observer controller.
  late final ListObserverController listObserverController;

  /// 记录当前手指所在的偏移量 / Current pointer offset.
  double observeOffset = 0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    listObserverController = ListObserverController(
      controller: scrollController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  /// 结束/取消 触摸
  void _onGestureEnd([_]) {
    widget.onSelectionEnd?.call();
  }

  /// 处理开始触摸以及触摸滑动
  void _onGestureHandler(dynamic details) async {
    // details 的类型有可能是 DragDownDetails，也有可能是 DragUpdateDetails
    if (details is! DragUpdateDetails &&
        details is! DragDownDetails &&
        details is! TapUpDetails) {
      return;
    }
    observeOffset = details.localPosition.dy;

    // 触发一次观察
    final result = await listObserverController.dispatchOnceObserve(
      isDependObserveCallback: false,
    );
    final observeResult = result.observeResult;
    if (observeResult == null) return;

    final firstChildModel = observeResult.firstChild;
    if (firstChildModel == null) return;

    final firstChildIndex = firstChildModel.index;
    final firstChildRenderObj = firstChildModel.renderObject;

    // 计算当前字母的中心点相对于父视图左上角的偏移量
    final firstChildRenderObjOffset = firstChildRenderObj.localToGlobal(
      Offset.zero,
      ancestor: widget.parentKey.currentContext?.findRenderObject(),
    );

    final cursorOffset = Offset(
      firstChildRenderObjOffset.dx,
      firstChildRenderObjOffset.dy + firstChildModel.size.width * 0.5,
    );
    widget.onSelectionUpdate?.call(firstChildIndex, cursorOffset);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _onGestureHandler,
      onVerticalDragDown: _onGestureHandler,
      onVerticalDragUpdate: _onGestureHandler,
      onVerticalDragCancel: _onGestureEnd,
      onVerticalDragEnd: _onGestureEnd,
      behavior: .opaque,
      child: ListViewObserver(
        controller: listObserverController,
        dynamicLeadingOffset: () => observeOffset,
        child: ListView.builder(
          controller: scrollController,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.symbols.length,
          itemBuilder: (BuildContext context, int index) {
            final bool isSelected = widget.selectedIndex == index;
            return AnimatedContainer(
              width: widget.indexBarSize,
              height: widget.indexBarSize,
              duration: widget.indexBarAnimatedContainerDuration,
              alignment: widget.indexBarItemAlignment ?? Alignment.center,
              decoration:
                  widget.indexBarBoxDecoration?.call(isSelected) ??
                  BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? widget.colorScheme.primary : null,
                  ),
              child: Text(
                widget.symbols[index],
                style:
                    widget.indexBarTextStyle?.call(isSelected) ??
                    TextStyle(
                      fontSize: 9,
                      color: isSelected ? widget.colorScheme.onPrimary : null,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
