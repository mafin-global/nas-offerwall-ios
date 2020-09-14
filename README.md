# NAS 오퍼월 iOS SDK 및 예제
NAS 오퍼월 iOS용 SDK 및 예제 프로그램을 제공합니다.

## 🔗 다른 플렛폼 SDK
- [`Android SDK`](https://github.com/mafin-global/nas-offerwall-android)
- [`Unity SDK`](https://github.com/mafin-global/nas-offerwall-unity)

## 📝 업데이트
- [`2020년 8월 21일`](docs/Update.md#2020년-8월-21일)
    - iOS 14 지원을 위한 SDK 배포
    - <font color="red">***!!! 이 SDK 는 iOS 14 버전 지원을 위한 테스트용 SDK 입니다. 상용 버전에 적용하면 안됩니다 !!!***</font>
    - XCode12 Beta 버전에서 SDK 및 예제를 사용해야 오류가 발생하지 않습니다.
    - [`SDK 연동 - 라이브러리 추가`](Guide.Embed.md#라이브러리-추가) 항목의 <font color="yellow">***노란색***</font>으로 표시된 항목을 추가 설정해주시기 바랍니다.
- [`2020년 3월 31일`](docs/Update.md#2020년-3월-31일)
    - 통신 관련 버그 수정
- [`2020년 1월 30일`](docs/Update.md#2020년-1월-30일---내장-ui) - _내장 UI_
    - foreground 시 새로고침되지 않는 버그 수정
- [`전체 업데이트 목록 보기`](docs/Update.md)

## 📖 문서
- [`내장 UI 개발 가이드`](docs/Guide.Embed.md) : 미리 만들어진 UI를 사용하는 방식으로, 별도의 UI 개발 없이 쉽게 연동할 수 있습니다.
- [`개발자 정의 UI 개발 가이드`](docs/Guide.Custom.md) : 개발자가 UI를 직접 만들어서 연동할 수 있는 방식으로, 개발자 앱의 UI에 맞게 자유롭게 구성할 수 있습니다.
- [`업데이트`](docs/Update.md) : SDK 업데이트 정보를 제공합니다.

## 📦 파일
- [`/sdk`](sdk) : 최종 릴리즈 SDK 파일
    - [`libNASWall_xxxxxxxx.a`](sdk/libNASWall_20200331.a) : SDK 라이브러리 파일
    - [`NASWall.h`](sdk/NASWall.h) : SDK 헤더 파일
- [`/example`](example) : 예제 소스
