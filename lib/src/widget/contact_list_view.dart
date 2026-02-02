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
    this.stickyHeaderAnimatedContainerDuration = const Duration(milliseconds: 150),
    this.stickyHeaderPadding,
    this.stickyHeaderBoxDecorationBuilder,
    this.stickyHeaderTextStyleBuilder,
    this.stickyHeaderAlignment,
  });

  final List<T> contactsList;

  final List<Widget> startSlivers;

  final List<Widget> endSlivers;

  final String Function(T model) tag;

  final ContactListItemBuilder<T> itemBuilder;

  final double cursorContainerSize;

  final double cursorPositionedRight;

  final ContactCursorBuilder? cursorBuilder;

  final bool sticky;

  final bool showStickyHeader;

  final double stickyHeaderHeight;

  final ContactStickyHeaderBuilder? stickyHeaderBuilder;

  final double indexBarPositionedRight;

  final double indexBarSize;

  final ContactIndexBarBoxDecorationBuilder? indexBarBoxDecorationBuilder;

  final ContactIndexBarTextStyleBuilder? indexBarTextStyleBuilder;

  final Alignment? indexBarAlignment;

  final Alignment? indexBarItemAlignment;

  final Duration cursorAnimatedPositionedDuration;

  final Duration indexBarAnimatedContainerDuration;

  final Duration stickyHeaderAnimatedContainerDuration;

  final EdgeInsets? stickyHeaderPadding;

  final ContactStickyHeaderBoxDecorationBuilder? stickyHeaderBoxDecorationBuilder;

  final ContactStickyHeaderTextStyleBuilder? stickyHeaderTextStyleBuilder;

  final Alignment? stickyHeaderAlignment;

  @override
  State<ContactListView<T>> createState() => _ContactListViewState<T>();
}

class _ContactListViewState<T> extends State<ContactListView<T>> {
  final GlobalKey _indexBarContainerKey = GlobalKey();

  late final ScrollController _scrollController;

  late final SliverObserverController _sliverObserverController;

  final Map<int, BuildContext> _sliverContextMap = <int, BuildContext>{};

  late List<ContactListModel<T>> _contactModelList = <ContactListModel<T>>[];

  late List<String> _symbols = <String>[];

  final Signal<ContactListCursorInfoModel?> _cursorInfo = Signal<ContactListCursorInfoModel?>(
    null,
    autoDispose: true,
  );

  final Signal<int> _selectIndex = Signal<int>(-1, autoDispose: true);

  /// 用于延迟更新选中状态的定时器
  late final Debounceable<bool, int> _schedulePinnedSelection = debounce<bool, int>(
    _updateSelection,
    debounceTime: const Duration(milliseconds: 10),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _sliverObserverController = SliverObserverController(controller: _scrollController);
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
    _cursorInfo.value = ContactListCursorInfoModel(title: _symbols[index], offset: cursorOffset);
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
                          widget.stickyHeaderBuilder?.call(contactListModel.tag, state.isPinned) ??
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
                            stickyHeaderTextStyleBuilder: widget.stickyHeaderTextStyleBuilder,
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
            cursorAnimatedPositionedDuration: widget.cursorAnimatedPositionedDuration,
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
                indexBarAnimatedContainerDuration: widget.indexBarAnimatedContainerDuration,
                colorScheme: colorScheme,
              );
            }),
          ),
        ),
      ],
    );
  }
}
