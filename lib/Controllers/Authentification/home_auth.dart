import 'dart:async';

enum screenStatus {
  HOME,
  LOGIN,
  REGISTER,
}

class HomeAuthController {
  StreamController<screenStatus> _streamController =
      StreamController<screenStatus>();

  HomeAuthController() {
    _streamController.add(screenStatus.HOME);
  }

  /// Update stream for displayed LOGIN screen
  login() {
    _streamController.add(screenStatus.LOGIN);
  }

  /// Update stream for displayed REGISTER screen
  register() {
    _streamController.add(screenStatus.REGISTER);
  }

  /// Retrieve stream
  StreamController<screenStatus> get streamController => _streamController;
}
