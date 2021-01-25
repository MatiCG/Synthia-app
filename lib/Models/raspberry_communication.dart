enum BLE_STATE {
  SCANNING,
  FOUNDED,
  CONNECTED,
  ERROR,
}

class RspyCommunicationModel {
  bool isBleOn = false;
  bool isBleSetup = false;
  String _bleAnim;
  BLE_STATE _bleState = BLE_STATE.SCANNING;

  /// Set the state of BLE connexion and assign a lottie url for annimation
  void setBleState(BLE_STATE state) {
    _bleState = state;
    switch (_bleState) {
      case BLE_STATE.SCANNING:
        _bleAnim = 'https://assets2.lottiefiles.com/packages/lf20_W8gUO8.json';
        break;
      case BLE_STATE.FOUNDED:
        _bleAnim =
            'https://assets5.lottiefiles.com/packages/lf20_ndlvehgz.json';
        break;
      case BLE_STATE.CONNECTED:
        _bleAnim =
            'https://assets5.lottiefiles.com/private_files/lf30_oaskv6es.json';
        break;
      case BLE_STATE.ERROR:
        _bleAnim =
            'https://assets2.lottiefiles.com/private_files/lf30_glnkkfua.json';
        break;
    }
  }

  /// Retrieve the url of the lottie animation depending of
  /// the current state of the BLE
  String get bleAnim => _bleAnim;

  /// Set the url of the lottie animation
  set bleUrl(String value) => _bleAnim = value;
}
