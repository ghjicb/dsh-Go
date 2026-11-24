import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 「显示会话权限胶囊」开关的持久化键（权限页写入，聊天页读取）。
const String kPrefSessionPill = 'session_perm_pill_visible';

/// 聊天页是否显示「完全权限」胶囊（会话权限）。
///
/// 权限页开关改它、聊天页 watch 它——跨页面即时生效，不用重启 App。
/// 与终端胶囊的 [chatPillsVisibleProvider] 完全独立：两个入口、两个功能。
final sessionPillVisibleProvider =
    NotifierProvider<SessionPillNotifier, bool>(SessionPillNotifier.new);

class SessionPillNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void set(bool value) => state = value;
}

/// 启动时从本地偏好载入一次；读失败保持默认（显示）。
Future<void> loadSessionPillVisible(WidgetRef ref) async {
  try {
    final p = await SharedPreferences.getInstance();
    ref.read(sessionPillVisibleProvider.notifier).set(p.getBool(kPrefSessionPill) ?? true);
  } catch (_) {
    // 读不到就按默认值来，不影响聊天。
  }
}
