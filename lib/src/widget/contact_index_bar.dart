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

  /// 父容器的 Key，用于计算游标相对位置
  final GlobalKey parentKey;

  /// 字母列表
  final List<String> symbols;

  /// 当前选中的字母索引
  final int selectedIndex;

  /// 选中字母变化时的回调
  final void Function(int index, Offset cursorOffset)? onSelectionUpdate;

  /// 选择结束时的回调
  final VoidCallback? onSelectionEnd;

  final double indexBarSize;

  final ContactIndexBarBoxDecorationBuilder? indexBarBoxDecoration;

  final ContactIndexBarTextStyleBuilder? indexBarTextStyle;

  final Alignment? indexBarItemAlignment;

  final Duration indexBarAnimatedContainerDuration;

  final ColorScheme colorScheme;

  @override
  State<ContactIndexBar> createState() => _ContactIndexBarState();
}

class _ContactIndexBarState extends State<ContactIndexBar> {
  late final ScrollController scrollController;

  late final ListObserverController listObserverController;

  /// 记录当前手指所在的偏移量
  double observeOffset = 0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    listObserverController = ListObserverController(controller: scrollController);
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
    if (details is! DragUpdateDetails && details is! DragDownDetails && details is! TapUpDetails) {
      return;
    }
    observeOffset = details.localPosition.dy;

    // 触发一次观察
    final result = await listObserverController.dispatchOnceObserve(isDependObserveCallback: false);
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
