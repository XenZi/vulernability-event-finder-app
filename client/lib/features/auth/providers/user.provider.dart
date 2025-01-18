import 'package:client/shared/models/user-state.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void clearEmail() {
    state = UserState();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(),
);
