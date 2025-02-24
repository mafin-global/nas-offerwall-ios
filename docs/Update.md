# 📝 NAS 오퍼월 iOS SDK 업데이트
NAS 오퍼월 iOS SDK의 업데이트 정보입니다.

## `2025년 2월 24일`
- iOS 18 openURL 관련 버그 수정

## `2024년 4월 15일`
- Privacy Manifest 를 위한 PrivacyInfo.xcprivacy 파일 제공
- /sdk/libNasWall_20240415.a SDK 파일도 반드시 업데이트 해주세요.
    > 5월 1일부터 NAS 오퍼월 SDK를 사용하는 앱을 App Store Connect에 업로드 하려면 반드시 [Privacy Manifest](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files) 를 적용해야합니다.
    > 
    > /sdk 폴더에 있는 PrivacyInfo.xcprivacy 파일에 NAS 오퍼월 SDK가 사용하는 Privacy Manifest 정보가 포함되어 있습니다.
    > 
    > 귀사의 PrivacyInfo.xcprivacy 파일에 내용을 추가하거나, /sdk 폴더에 있는 파일을 사용하시기 바랍니다.

## `2020년 9월 16일`
- iOS 14 지원을 위한 SDK 배포
    > iOS 14 부터는 사용자 구분을 위해 필요한 IDFA 값을 획득하기 위해 추적권한 요청이 필요합니다.
    >
    > API 사용 시 자동으로 추적권한 요청 팝업이 표시되도록 수정되었습니다. 
    >
    > 추가된 설정 내용은 [`SDK 연동 - 라이브러리 추가`](Guide.Embed.md#라이브러리-추가) 항목을 참고해주세요.
    >
    > ***XCode 12 이상 버전에서 사용해야 합니다.***
## `2020년 3월 31일`
- 통신 관련 버그 수정
    
## `2020년 1월 30일` - _내장 UI_
- foreground 시 새로고침되지 않는 버그 수정
    
## `2020년 1월 28일` - _내장 UI_
- 환경에 따라 오퍼월이 보이지 않는 현상 수정

## `2019년 11월 18일` - _내장 UI_
- UIWebView -> WKWebView 변경

## `2019년 04월 30일` - _내장 UI_
- 문의하기 화면에서 Back 시 화면 사라지는 현상 수정

## `2016년 11월 24일`
- 내부 통신 프로토콜 https로 변경

## 📖 다른 문서
- [`내장 UI 개발 가이드`](Guide.Embed.md) : 미리 만들어진 UI를 사용하는 방식으로, 별도의 UI 개발 없이 쉽게 연동할 수 있습니다.
- [`개발자 정의 UI 개발 가이드`](Guide.Custom.md) : 개발자가 UI를 직접 만들어서 연동할 수 있는 방식으로, 개발자 앱의 UI에 맞게 자유롭게 구성할 수 있습니다.

## 🔗 다른 플렛폼 SDK
- [`Android SDK`](https://github.com/mafin-global/nas-offerwall-android)
- [`Unity SDK`](https://github.com/mafin-global/nas-offerwall-unity)
