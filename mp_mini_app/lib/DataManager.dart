import 'dart:convert';
import 'dart:js';
import 'dart:js' as js;
import 'dart:html' as html; 

var env = ENV.DEV;

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() => _instance;

  DataManager._internal();

  static DataManager get instance => _instance;

  String? _token;

  void setToken(String value) {
    _token = value;
  }

  String? getToken() {
    return _token;
  }

  void getTokenFromMini({required Function(UserStateModel) onState}) async {
    if (env == ENV.DEV) {
      getTokenData(onState: onState);
    } else {
      getTokenWhenBuildFile(onState: onState);
    }
  }

  Future<void> getTokenData({required Function(UserStateModel) onState}) async {
    onState(UserStateModel(LoadState.loading, '...'));

    js.context['receiveFromHost'] = allowInterop((dynamic jsonData) {
      String? tokenAccess;

      print("dataaaaa neeeeee ");
      if (jsonData is JsObject) {
        tokenAccess = jsonData['token'];
        print("dataaaaa neeeeee ${tokenAccess}");
      } else if (jsonData is String) {
        try {
          final data = jsonDecode(jsonData);
          tokenAccess = data['token'];
        } catch (_) {}
      }

      if (tokenAccess != null) {
        _token = tokenAccess;
        onState(UserStateModel(LoadState.success, tokenAccess));
      } else {
        onState(UserStateModel(LoadState.fail, "Unknown"));
      }
    });
  }

  void getTokenWhenBuildFile({required Function(UserStateModel) onState}) {
    onState(UserStateModel(LoadState.loading, '...'));

    // Dùng window.onMessage từ dart:html
    html.window.onMessage.listen((event) {
      dynamic data = event.data;
      String? tokenAccess;

      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          tokenAccess = decoded['token'];
        } catch (_) {}
      } else if (data is Map) {
        tokenAccess = data['token'];
      }

      if (tokenAccess != null) {
        _token = tokenAccess;
        onState(UserStateModel(LoadState.success, tokenAccess));
      } else {
        onState(UserStateModel(LoadState.fail, "Unknown"));
      }
    });
  }
}

enum LoadState { loading, success, fail }

enum ENV { DEV, PROD }

class UserStateModel {
  final LoadState state;
  final String username;

  UserStateModel(this.state, this.username);
}
