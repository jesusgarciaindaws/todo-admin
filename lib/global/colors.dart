import 'dart:ui';
import '../models/common/login.dart';

const Color _primary = Color(0xff0272E7);

class GlobalColors {
  Color loginState(LoginState state) {
    switch (state) {
      case LoginState.active:
        return _primary;
      case LoginState.inactive:
        return const Color(0xff777777);
      case LoginState.unconfirmed:
        return const Color(0xff777777);
      case LoginState.removed:
        return const Color(0xff777777);
    }
    return null;
  }
}