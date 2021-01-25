enum BLE_STATE {
  SCANNING,
  FOUNDED,
  CONNECTED,
  ERROR,
}

class RspyCommunicationModel {
  BLE_STATE _bleState = BLE_STATE.SCANNING;
  String _lottieUrl = '';
  bool bleIsOn = false;
  bool bleConfigDone = false;

  bool get bleConfig {
    return bleConfigDone;
  }

  set bleConfig(bool conf) {
    bleConfigDone = conf;
  }

  bool get bleStatus {
    return bleIsOn;
  }

  set bleStatus(bool status) {
    bleIsOn = status;
  }

  /// Set the value of the ble state
  void setBleState(BLE_STATE state) {
    _bleState = state;
    switch (_bleState) {
      case BLE_STATE.SCANNING:
        _lottieUrl =
            'https://assets2.lottiefiles.com/packages/lf20_W8gUO8.json';
        break;
      case BLE_STATE.FOUNDED:
        _lottieUrl =
            'https://assets5.lottiefiles.com/packages/lf20_ndlvehgz.json';
        break;
      case BLE_STATE.CONNECTED:
        _lottieUrl =
            'https://assets5.lottiefiles.com/private_files/lf30_oaskv6es.json';
        break;
      case BLE_STATE.ERROR:
        _lottieUrl =
            'https://assets2.lottiefiles.com/private_files/lf30_glnkkfua.json';
        break;
    }
  }

  /// Retrieve the value of the ble state.
  BLE_STATE getBleState() {
    return _bleState;
  }

  /// Retrieve the value of the lottie file
  String getLottieUrl() {
    return _lottieUrl;
  }

  /// Set the value of the lottie file
  void setLottieUrl(String value) {
    _lottieUrl = value;
  }
}
