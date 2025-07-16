import 'dart:js' as js;

class CallbackToHostMethod {
  static final CallbackToHostMethod _instance =
      CallbackToHostMethod._internal();

  factory CallbackToHostMethod() => _instance;

  CallbackToHostMethod._internal();

  static CallbackToHostMethod get instance => _instance;

// Gọi hàm bên Host
  void sendReloadCommandToHost() {
    js.context['location'].callMethod('restart');

    js.context.callMethod('receiveFromMini', [
      js.JsObject.jsify({
        'reload': true,
        'reason': 'User clicked button in mini',
      })
    ]);
  }
}
