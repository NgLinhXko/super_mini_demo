# SuperMiniDemo direction

## Chức năng các folder
- **Flutter:/**: 3.19.6
- **Dart:/**: 3.3.4
- **JDK/**: jdk11

- **flutter_host_app/**: Là project Super (host app), ứng dụng chính chứa WebView để nhúng mini app.
- **mp_mini_app/**: Là project Mini App, ứng dụng con chạy độc lập, có thể nhúng vào host app qua WebView.
- **host_app_sdk/**: Chứa SDK, các thư viện, file tạm (lib, temp) để implement vào host app, hỗ trợ giao tiếp giữa host và mini app.

## Hướng dẫn chạy local

### 1. Run mini app trên localhost
```bash
fvm flutter run -d web-server --web-port=3000 --web-hostname=0.0.0.0
```

### 2. Trỏ WebView trong host app về địa chỉ:
```
http://10.0.2.2:3000 (dành cho Android emulator)
```

### 3. Cấu hình Android
- Thêm `android:usesCleartextTraffic="true"` vào đúng vị trí trong file `AndroidManifest.xml`.
- Thêm quyền `INTERNET` vào manifest.
- Build và run lại app host sau khi chỉnh cấu hình.

## Checklist các việc đã làm

| Việc đã làm                                                                 | Trạng thái |
|-----------------------------------------------------------------------------|:----------:|
| Run mini app bằng `fvm flutter run -d web-server --web-port=3000 --web-hostname=0.0.0.0` |    ✅     |
| Trỏ WebView trong host về `http://10.0.2.2:3000` (Android emulator)         |    ✅     |
| Thêm `android:usesCleartextTraffic="true"` đúng chỗ trong AndroidManifest.xml |    ✅     |
| Cho phép INTERNET permission                                                |    ✅     |
| Build và run lại app host sau khi chỉnh cấu hình                            |    ✅     |

## Hướng dẫn build & deploy production (ENV.PROD)

1. Build mini app:
   ```bash
   fvm flutter build web
   ```
2. Cài đặt firebase tools:
   ```bash
   npm install -g firebase-tools
   ```
3. Kiểm tra phiên bản firebase:
   ```bash
   firebase --version
   ```
4. Đăng nhập firebase:
   ```bash
   firebase login
   ```
5. Khởi tạo firebase:
   ```bash
   firebase init
   ```
6. Deploy lên firebase:
   ```bash
   firebase deploy
   ```
7. Hoặc deploy lên bất kỳ host nào khác tùy ý.


### 4. Sử dụng library 
gọi hàm 
```bash
   HostAppSDK.openMiniApp(url, data)
   ```
