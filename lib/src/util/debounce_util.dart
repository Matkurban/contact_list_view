import 'dart:async';

/// 默认防抖时间 / Default debounce duration.
const Duration debounceDuration = Duration(milliseconds: 500);

typedef Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
Debounceable<S, T> debounce<S, T>(
  Debounceable<S?, T> function, {
  Duration? debounceTime,
}) {
  DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = DebounceTimer(debounceTime: debounceTime);
    try {
      await debounceTimer!.future;
    } on _CancelException {
      return null;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class DebounceTimer {
  /// 自定义防抖时间 / Custom debounce duration.
  final Duration? debounceTime;

  DebounceTimer({this.debounceTime}) {
    _timer = Timer(debounceTime ?? debounceDuration, _onComplete);
  }

  /// 内部定时器 / Internal timer.
  late final Timer _timer;

  /// 完成通知器 / Completion notifier.
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}
