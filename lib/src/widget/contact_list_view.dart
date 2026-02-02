import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:signals/signals_flutter.dart';

import '../define/define_type.dart';
import '../model/contact_list_cursor_info_model.dart';
import '../model/contact_list_model.dart';
import '../util/debounce_util.dart';
import 'contact_cursor.dart';
import 'contact_index_bar.dart';
import 'contact_sticky_header.dart';

class ContactListView<T> extends StatefulWidget {
  const ContactListView({
    super.key,
    required this.contactsList,
    this.startSlivers = const <Widget>[],
    this.endSlivers = const <Widget>[],
    required this.tag,
    required this.itemBuilder,
    this.sticky = true,
    this.showStickyHeader = true,
    this.stickyHeaderHeight = 32,
    this.stickyHeaderBuilder,
    this.cursorContainerSize = 40,
    this.cursorPositionedRight = 32,
    this.cursorBuilder,
    this.indexBarPositionedRight = 4,
    this.indexBarSize = 16,
    this.indexBarBoxDecorationBuilder,
    this.indexBarTextStyleBuilder,
    this.indexBarAlignment,
    this.indexBarItemAlignment,
    this.cursorAnimatedPositionedDuration = const Duration(milliseconds: 150),
    this.indexBarAnimatedContainerDuration = const Duration(milliseconds: 150),
    this.stickyHeaderAnimatedContainerDuration = const Duration(
      milliseconds: 150,
    ),
    this.stickyHeaderPadding,
    this.stickyHeaderBoxDecorationBuilder,
    this.stickyHeaderTextStyleBuilder,
    this.stickyHeaderAlignment,
  });

  /// 联系人列表 / Source contact list.
  final List<T> contactsList;

  /// 列表头部 Sliver / Leading slivers.
  final List<Widget> startSlivers;

  /// 列表尾部 Sliver / Trailing slivers.
  final List<Widget> endSlivers;

  /// 标签提取器 / Tag selector.
  final String Function(T model) tag;

  /// 列表项构建器 / Item builder.
  final ContactListItemBuilder<T> itemBuilder;

  /// 游标容器尺寸 / Cursor container size.
  final double cursorContainerSize;

  /// 游标右侧偏移 / Cursor right offset.
  final double cursorPositionedRight;

  /// 游标构建器 / Cursor builder.
  final ContactCursorBuilder? cursorBuilder;

  /// 是否启用粘性头部 / Enable sticky headers.
  final bool sticky;

  /// 是否显示头部 / Show sticky header.
  final bool showStickyHeader;

  /// 头部高度 / Sticky header height.
  final double stickyHeaderHeight;

  /// 头部构建器 / Sticky header builder.
  final ContactStickyHeaderBuilder? stickyHeaderBuilder;

  /// 索引条右侧偏移 / Index bar right offset.
  final double indexBarPositionedRight;

  /// 索引条尺寸 / Index bar item size.
  final double indexBarSize;

  /// 索引条背景构建器 / Index bar decoration builder.
  final ContactIndexBarBoxDecorationBuilder? indexBarBoxDecorationBuilder;

  /// 索引条文字样式 / Index bar text style builder.
  final ContactIndexBarTextStyleBuilder? indexBarTextStyleBuilder;

  /// 索引条整体对齐 / Index bar alignment.
  final Alignment? indexBarAlignment;

  /// 索引条项对齐 / Index bar item alignment.
  final Alignment? indexBarItemAlignment;

  /// 游标动画时长 / Cursor animation duration.
  final Duration cursorAnimatedPositionedDuration;

  /// 索引条动画时长 / Index bar animation duration.
  final Duration indexBarAnimatedContainerDuration;

  /// 头部动画时长 / Sticky header animation duration.
  final Duration stickyHeaderAnimatedContainerDuration;

  /// 头部内边距 / Sticky header padding.
  final EdgeInsets? stickyHeaderPadding;

  /// 头部背景构建器 / Sticky header decoration builder.
  final ContactStickyHeaderBoxDecorationBuilder?
  stickyHeaderBoxDecorationBuilder;

  /// 头部文字样式 / Sticky header text style builder.
  final ContactStickyHeaderTextStyleBuilder? stickyHeaderTextStyleBuilder;

  /// 头部对齐 / Sticky header alignment.
  final Alignment? stickyHeaderAlignment;

  @override
  State<ContactListView<T>> createState() => _ContactListViewState<T>();
}

class _ContactListViewState<T> extends State<ContactListView<T>> {
  /// 索引条容器 Key / Index bar container key.
  final GlobalKey _indexBarContainerKey = GlobalKey();

  /// 列表滚动控制器 / Scroll controller.
  late final ScrollController _scrollController;

  /// Sliver 观察控制器 / Sliver observer controller.
  late final SliverObserverController _sliverObserverController;

  /// Sliver Context 缓存 / Sliver context cache.
  final Map<int, BuildContext> _sliverContextMap = <int, BuildContext>{};

  /// 分组后的联系人 / Grouped contacts.
  late List<ContactListModel<T>> _contactModelList = <ContactListModel<T>>[];

  /// 索引字母列表 / Index symbols.
  late List<String> _symbols = <String>[];

  /// 游标信息信号 / Cursor info signal.
  final Signal<ContactListCursorInfoModel?> _cursorInfo =
      Signal<ContactListCursorInfoModel?>(null, autoDispose: true);

  /// 当前选中索引 / Selected index.
  final Signal<int> _selectIndex = Signal<int>(-1, autoDispose: true);

  /// 用于延迟更新选中状态的定时器 / Debounced selection updater.
  late final Debounceable<bool, int> _schedulePinnedSelection =
      debounce<bool, int>(
        _updateSelection,
        debounceTime: const Duration(milliseconds: 10),
      );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _sliverObserverController = SliverObserverController(
      controller: _scrollController,
    );
    _generateContactList();
  }

  @override
  void didUpdateWidget(covariant ContactListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _generateContactList();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _generateContactList() {
    final Map<String, List<T>> contactMap = <String, List<T>>{};
    for (T model in widget.contactsList) {
      String tag = widget.tag(model);
      if (contactMap.containsKey(tag)) {
        contactMap[tag]!.add(model);
      } else {
        contactMap[tag] = [model];
      }
    }
    final List<ContactListModel<T>> list = <ContactListModel<T>>[];
    contactMap.forEach((key, value) {
      value.sort((a, b) {
        return widget.tag(a).compareTo(widget.tag(b));
      });
      list.add(ContactListModel<T>(tag: key, contacts: value));
    });
    list.sort((a, b) {
      if (a.tag == '#') return 1;
      if (b.tag == '#') return -1;
      return a.tag.compareTo(b.tag);
    });
    _sliverContextMap.clear();
    _contactModelList = list;
    _symbols = _contactModelList.map((item) => item.tag).toList();
  }

  /// 当 sticky header 固定时，延迟更新选中状态
  ///
  /// 避免频繁更新导致的性能问题
  Future<bool> _updateSelection(int index) async {
    _selectIndex.value = index;
    return true;
  }

  /// 字母索引选中时的回调
  ///
  /// [index] 选中的字母索引
  /// [cursorOffset] 游标显示位置
  void _onSelectionUpdate(int index, Offset cursorOffset) {
    // 更新游标数据，来显示游标
    _cursorInfo.value = ContactListCursorInfoModel(
      title: _symbols[index],
      offset: cursorOffset,
    );
    // 取出字母对应的联系人列表视图 SliverList 的 BuildContext
    final sliverContext = _sliverContextMap[index];
    if (sliverContext == null) return;
    // 跳到对应的字母章节的第一个 item 的位置
    _sliverObserverController.jumpTo(
      index: 0,
      sliverContext: sliverContext,
      renderSliverType: ObserverRenderSliverType.list,
    );
  }

  /// 字母索引选中结束时的回调
  void _onSelectionEnd() {
    // 清除游标数据，即隐藏游标
    _cursorInfo.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Stack(
      children: [
        SliverViewObserver(
          controller: _sliverObserverController,
          sliverContexts: () => _sliverContextMap.values.toList(),
          onObserveViewport: (result) {
            SliverViewportObserveDisplayingChildModel model = result.firstChild;
            _sliverContextMap.entries.map((entry) {
              if (entry.value == model.sliverContext) {
                _selectIndex.value = entry.key;
              }
            });
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              ...widget.startSlivers,
              ..._contactModelList.asMap().entries.map((entry) {
                int index = entry.key;
                final ContactListModel<T> contactListModel = entry.value;
                return SliverStickyHeader.builder(
                  builder: (context, state) {
                    if (state.isPinned) {
                      _schedulePinnedSelection(index);
                    }
                    return Visibility(
                      visible: widget.showStickyHeader,
                      replacement: SizedBox(height: 0.1),
                      child:
                          widget.stickyHeaderBuilder?.call(
                            contactListModel.tag,
                            state.isPinned,
                          ) ??
                          ContactStickyHeader(
                            stickyHeaderHeight: widget.stickyHeaderHeight,
                            tag: contactListModel.tag,
                            isPinned: state.isPinned,
                            stickyHeaderAnimatedContainerDuration:
                                widget.stickyHeaderAnimatedContainerDuration,
                            sticky: widget.sticky,
                            stickyHeaderPadding: widget.stickyHeaderPadding,
                            stickyHeaderAlignment: widget.stickyHeaderAlignment,
                            stickyHeaderBoxDecorationBuilder:
                                widget.stickyHeaderBoxDecorationBuilder,
                            stickyHeaderTextStyleBuilder:
                                widget.stickyHeaderTextStyleBuilder,
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                          ),
                    );
                  },
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, modelIndex) {
                      _sliverContextMap[index] ??= context;
                      final T model = contactListModel.contacts[modelIndex];
                      return widget.itemBuilder(model);
                    }, childCount: contactListModel.contacts.length),
                  ),
                );
              }),
              ...widget.endSlivers,
            ],
          ),
        ),
        Watch((context) {
          return ContactCursor(
            cursorInfo: _cursorInfo.value,
            cursorContainerSize: widget.cursorContainerSize,
            cursorPositionedRight: widget.cursorPositionedRight,
            cursorBuilder: widget.cursorBuilder,
            cursorAnimatedPositionedDuration:
                widget.cursorAnimatedPositionedDuration,
            textTheme: textTheme,
            colorScheme: colorScheme,
          );
        }),
        Positioned(
          top: 0,
          right: widget.indexBarPositionedRight,
          bottom: 0,
          child: Container(
            key: _indexBarContainerKey,
            width: widget.indexBarSize,
            alignment: widget.indexBarAlignment ?? Alignment.center,
            child: Watch((context) {
              return ContactIndexBar(
                parentKey: _indexBarContainerKey,
                symbols: _symbols.toList(),
                selectedIndex: _selectIndex.value,
                onSelectionUpdate: _onSelectionUpdate,
                onSelectionEnd: _onSelectionEnd,
                indexBarSize: widget.indexBarSize,
                indexBarBoxDecoration: widget.indexBarBoxDecorationBuilder,
                indexBarTextStyle: widget.indexBarTextStyleBuilder,
                indexBarItemAlignment: widget.indexBarItemAlignment,
                indexBarAnimatedContainerDuration:
                    widget.indexBarAnimatedContainerDuration,
                colorScheme: colorScheme,
              );
            }),
          ),
        ),
      ],
    );
  }
}
