import 'dart:async';

enum screenStatus {
  home,
  login,
  register,
}

class HomeAuthController {
  final StreamController<screenStatus> _streamController =
      StreamController<screenStatus>();

  HomeAuthController() {
    _streamController.add(screenStatus.home);
  }

  /// Update stream for displayed LOGIN screen
  void login() {
    _streamController.add(screenStatus.login);
  }

  /// Update stream for displayed REGISTER screen
  void register() {
    _streamController.add(screenStatus.register);
  }

  /// Retrieve stream
  StreamController<screenStatus> get streamController => _streamController;
}
