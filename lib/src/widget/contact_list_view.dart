import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:signals/signals_flutter.dart';

import '../define/define_type.dart';
import '../model/contact_list_cursor_info_model.dart';
import '../model/contact_list_model.dart';
import '../util/debounce_util.dart';
import 'contact_cursor_widget.dart';
import 'contact_index_bar_widget.dart';
import 'contact_list_section_header.dart';

class ContactListView<T> extends StatefulWidget {
  const ContactListView({
    super.key,
    required this.contactsList,
    this.startSlivers = const <Widget>[],
    this.endSlivers = const <Widget>[],
    required this.tag,
    required this.contactListItemBuilder,
    this.showSectionHeader = true,
    this.contactListSectionHeaderBuilder,
    this.cursorContainerSize = 40,
    this.cursorPositionedRight = 32,
    this.cursorBuilder,
  });

  final List<T> contactsList;

  final List<Widget> startSlivers;

  final List<Widget> endSlivers;

  final String Function(T model) tag;

  final ContactListItemBuilder<T> contactListItemBuilder;

  final double cursorContainerSize;

  final double cursorPositionedRight;

  final CursorBuilder? cursorBuilder;

  ///是否显示吸顶
  final bool showSectionHeader;

  final ContactSectionHeaderBuilder? contactListSectionHeaderBuilder;

  @override
  State<ContactListView<T>> createState() => _ContactListViewState<T>();
}

class _ContactListViewState<T> extends State<ContactListView<T>> {
  final GlobalKey indexBarContainerKey = GlobalKey();

  late final ScrollController scrollController;

  late final SliverObserverController sliverObserverController;

  final Map<int, BuildContext> sliverContextMap = <int, BuildContext>{};

  late List<ContactListModel<T>> contactModelList = <ContactListModel<T>>[];

  late List<String> symbols = <String>[];

  final Signal<ContactListCursorInfoModel?> cursorInfo = Signal<ContactListCursorInfoModel?>(
    null,
    autoDispose: true,
  );

  final Signal<int> selectIndex = Signal<int>(-1, autoDispose: true);

  /// 用于延迟更新选中状态的定时器
  late final Debounceable<bool, int> schedulePinnedSelection = debounce<bool, int>(
    updateSelection,
    debounceTime: const Duration(milliseconds: 10),
  );

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    sliverObserverController = SliverObserverController(controller: scrollController);
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
    scrollController.dispose();
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
    sliverContextMap.clear();
    contactModelList = list;
    symbols = contactModelList.map((item) => item.tag).toList();
  }

  /// 当 sticky header 固定时，延迟更新选中状态
  ///
  /// 避免频繁更新导致的性能问题
  Future<bool> updateSelection(int index) async {
    selectIndex.value = index;
    return true;
  }

  /// 字母索引选中时的回调
  ///
  /// [index] 选中的字母索引
  /// [cursorOffset] 游标显示位置
  void onSelectionUpdate(int index, Offset cursorOffset) {
    // 更新游标数据，来显示游标
    cursorInfo.value = ContactListCursorInfoModel(title: symbols[index], offset: cursorOffset);
    // 取出字母对应的联系人列表视图 SliverList 的 BuildContext
    final sliverContext = sliverContextMap[index];
    if (sliverContext == null) return;
    // 跳到对应的字母章节的第一个 item 的位置
    sliverObserverController.jumpTo(
      index: 0,
      sliverContext: sliverContext,
      renderSliverType: ObserverRenderSliverType.list,
    );
  }

  /// 字母索引选中结束时的回调
  void onSelectionEnd() {
    // 清除游标数据，即隐藏游标
    cursorInfo.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Stack(
      children: [
        EasyRefresh(
          child: SliverViewObserver(
            controller: sliverObserverController,
            sliverContexts: () => sliverContextMap.values.toList(),
            onObserveViewport: (result) {
              SliverViewportObserveDisplayingChildModel model = result.firstChild;
              sliverContextMap.entries.map((entry) {
                if (entry.value == model.sliverContext) {
                  selectIndex.value = entry.key;
                }
              });
            },
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                ...widget.startSlivers,
                ...contactModelList.asMap().entries.map((entry) {
                  int index = entry.key;
                  final ContactListModel<T> contactListModel = entry.value;
                  return SliverStickyHeader.builder(
                    builder: (context, state) {
                      if (state.isPinned) {
                        schedulePinnedSelection(index);
                      }
                      return Visibility(
                        visible: widget.showSectionHeader,
                        child:
                            widget.contactListSectionHeaderBuilder?.call(
                              contactListModel.tag,
                              state.isPinned,
                            ) ??
                            ContactListSectionHeader(
                              tag: contactListModel.tag,
                              isPinned: state.isPinned,
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            ),
                      );
                    },
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, modelIndex) {
                        sliverContextMap[index] ??= context;
                        final T model = contactListModel.contacts[modelIndex];
                        return widget.contactListItemBuilder(model);
                      }, childCount: contactListModel.contacts.length),
                    ),
                  );
                }),
                ...widget.endSlivers,
              ],
            ),
          ),
        ),
        Watch((context) {
          return ContactCursorWidget(
            cursorInfo: cursorInfo.value,
            cursorContainerSize: widget.cursorContainerSize,
            cursorPositionedRight: widget.cursorPositionedRight,
            cursorBuilder: widget.cursorBuilder,
            textTheme: textTheme,
            colorScheme: colorScheme,
          );
        }),
        Positioned(
          top: 0,
          right: 4,
          bottom: 0,
          child: Container(
            key: indexBarContainerKey,
            width: 24,
            alignment: Alignment.center,
            child: Watch((context) {
              return ContactIndexBarWidget(
                parentKey: indexBarContainerKey,
                symbols: symbols.toList(),
                selectedIndex: selectIndex.value,
                colorScheme: colorScheme,
                onSelectionUpdate: onSelectionUpdate,
                onSelectionEnd: onSelectionEnd,
              );
            }),
          ),
        ),
      ],
    );
  }
}
