# marthos_po

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase 설정 방법

이 앱은 Firebase Authentication을 사용하여 구글 로그인 기능을 구현합니다. 앱을 실행하기 전에 다음 단계를 완료해야 합니다:

1. [Firebase 콘솔](https://console.firebase.google.com/)에서 새 프로젝트를 생성합니다.
2. 프로젝트에 앱을 등록합니다 (Android, iOS, Web 등).
3. FlutterFire CLI를 설치합니다:
   ```bash
   dart pub global activate flutterfire_cli
   ```
4. 프로젝트 루트 디렉토리에서 다음 명령어를 실행하여 Firebase 구성을 설정합니다:
   ```bash
   flutterfire configure --project=<firebase-project-id>
   ```
   이 명령어는 `lib/firebase_options.dart` 파일을 자동으로 생성합니다.

5. Android, iOS, macOS 플랫폼에서 Google 로그인을 사용하려면 각 플랫폼별로 추가 설정이 필요합니다:

   ### Android
   - `android/app/build.gradle`에서 `minSdkVersion`이 21 이상인지 확인합니다.
   - Firebase 콘솔에서 생성한 `google-services.json` 파일을 `android/app/` 디렉토리에 추가합니다.

   ### iOS
   - Firebase 콘솔에서 생성한 `GoogleService-Info.plist` 파일을 XCode를 통해 Runner 프로젝트에 추가합니다.
   - `ios/Runner/Info.plist`에 다음을 추가합니다:
     ```xml
     <key>CFBundleURLTypes</key>
     <array>
       <dict>
         <key>CFBundleTypeRole</key>
         <string>Editor</string>
         <key>CFBundleURLSchemes</key>
         <array>
           <string>REVERSED_CLIENT_ID</string>
         </array>
       </dict>
     </array>
     ```
     `REVERSED_CLIENT_ID`는 `GoogleService-Info.plist` 파일에서 찾을 수 있습니다.

자세한 설정 방법은 다음 문서를 참조하세요:
- [FlutterFire 설정 가이드](https://firebase.flutter.dev/docs/overview)
- [Firebase Authentication](https://firebase.flutter.dev/docs/auth/overview)
- [Google Sign-In](https://pub.dev/packages/google_sign_in)
