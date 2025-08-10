import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  bool build() => false;

  Future<void> login() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));

    state = true;
  }

  void logout() {
    state = false;
  }
}
