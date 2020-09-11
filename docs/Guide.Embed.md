# 📖 NAS 오퍼월 iOS SDK - 내장 UI 개발 가이드
이 문서는 NAS 오퍼월 SDK 내장 UI 연동 가이드를 제공합니다.

오퍼월 UI 표시 방식은 다음 두가지를 지원합니다.

- `내장 UI` : 미리 만들어진 UI를 사용하는 방식으로, 별도의 UI 개발 없이 쉽게 연동할 수 있습니다.
- `개발자 정의 UI` : 개발자가 UI를 직접 만들어서 연동할 수 있는 방식으로, 개발자 앱의 UI에 맞게 자유롭게 구성할 수 있습니다.

`개발자 정의 UI`를 사용 하려면, [📖 개발자 정의 UI 개발 가이드](Guide.Custom.md) 문서를 참고해 주시기 랍니다.

## 목차
- [📝⠀업데이트](#-업데이트)
- [👤️⠀개발자/매체 등록](#%EF%B8%8F-개발자-매체-등록)
- [🚀⠀SDK 연동](#-sdk-연동)
    - [라이브러리 추가](#라이브러리-추가)
    - [초기화](#초기화)
    - [추가 설정](#추가-설정)
    - [팝업 오퍼월 띄우기](#팝업-오퍼월-띄우기)
    - [임베드 오퍼월 삽입](#임베드-오퍼월-삽입)
    - [적립금 조회](#적립금-조회-nas-서버에서-적립금-관리-시-사용) _(NAS 서버에서 적립금 관리 시 사용)_
    - [적립금 사용 (아이템 구매)](#적립금-사용-아이템-구매-nas-서버에서-적립금-관리-시-사용) _(NAS 서버에서 적립금 관리 시 사용)_
    - [이벤트](#이벤트-공통) _(공통)_
        - [오퍼월 종료 (NASWallClose)](#오퍼월-종료-naswallclose)
    - [이벤트](#이벤트-nas-서버에서-적립금-관리-시-사용) _(NAS 서버에서 적립금 관리 시 사용)_
        - [적립금 조회 성공 (NASWallGetUserPointSuccess)](#적립금-조회-성공-naswallgetuserpointsuccess)
        - [적립금 조회 실패 (NASWallGetUserPointError)](#적립금-조회-실패-naswallgetuserpointerror)
        - [아이템 구매 성공 (NASWallPurchaseItemSuccess)](#아이템-구매-성공-naswallpurchaseitemsuccess)
        - [아이템 구매 적립금 부족 (NASWallPurchaseItemNotEnoughPoint)](#아이템-구매-적립금-부족-naswallpurchaseitemnotenoughpoint)
        - [아이템 구매 실패 (NASWallPurchaseItemError)](#아이템-구매-실패-naswallpurchaseitemerror)

## 📝 업데이트
- [`2020년 3월 31일`](Update.md#2020년-3월-31일)
    - 통신 관련 버그 수정
- [`2020년 1월 30일`](Update.md#2020년-1월-30일---내장-ui) - _내장 UI_
    - foreground 시 새로고침되지 않는 버그 수정
- [`2020년 1월 28일`](Update.md#2020년-1월-28일---내장-ui) - _내장 UI_
    - 환경에 따라 오퍼월이 보이지 않는 현상 수정
- [전체 업데이트 목록 보기](Update.md)

## 👤️ 개발자/매체 등록
[오퍼월 적용 가이드 문서](https://github.com/mafin-global/nas-offerwall#%EF%B8%8F-%EA%B0%9C%EB%B0%9C%EC%9E%90-%EB%93%B1%EB%A1%9D) 를 참고해주세요.

## 🚀 SDK 연동

### `라이브러리 추가`
`/sdk` 폴더의 `libNASWall.a`, `NASWall.h` 파일을 프로젝트에 추가합니다.

`프로젝트 설정` > `Build Phases` > `Link Binary With Libraries` 에서 다음 라이브러리를 추가합니다.

- libNASWall.a
- AdSupport.framework
- Security.framework
- WebKit.framework
- SystemConfiguration.framework

AdSupport.framework 의 Status 는 Optional 로 변경합니다.

### `초기화`
오퍼월을 사용하기 앞서 `초기화 함수`를 먼저 호출합니다.

- ***개발자 서버에서 적립금 관리 시 사용***
    - `appKey` : 앱 등록 후 받은 32자리 키를 입력합니다.
    - `testMode` : 개발 `테스트 버전인 경우에만 YES`를 입력하고, `배포 버전에서는 NO`를 입력합니다.
    - `userId` : 사용자를 구분하기 위한 ID입니다. NAS 서버에서 `사용자 ID` 별로 적립금이 쌓이기 때문에 사용자별로 고유한 값을 입력해야합니다.
    - `delegate` : SDK의 `이벤트`를 받을 객체를 지정합니다.
    ```
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        [NASWall initWithAppKey:@"앱KEY" testMode:NO userId:@"사용자ID" delegate:self];
        ...
    }
    ```
 
- ***NAS 서버에서 적립금 관리 시 사용***
    - `appKey` : 앱 등록 후 받은 32자리 키를 입력합니다.
    - `testMode` : 개발 `테스트 버전인 경우에만 YES`를 입력하고, `배포 버전에서는 NO`를 입력합니다.
    - `delegate` : SDK의 `이벤트`를 받을 객체를 지정합니다.
    ```
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        [NASWall initWithAppKey:@"앱KEY" testMode:testMode delegate:self];
        ...
    }
    ```

### `추가 설정`
`AppDelegate` 클래스의 `applicationDidEnterBackground`, `applicationWilEnterForeground` 함수에 다음 코드를 추가합니다.

```
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [NASWall applicationDidEnterBackground];
    ...
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [NASWall applicationWillEnterForeground];
    ...
}
```

### `팝업 오퍼월 띄우기`
`팝업` 형식으로 오퍼월을 보여주고자 하는 경우에 사용합니다.

- ***개발자 서버에서 적립금 관리 시 사용***
    > `USER_DATA`에 개발자가 사용자를 구분하기 위한 값을 입력합니다. 광고 참여 완료 후 개발자 서버로 `콜백 URL` 호출 시. `[USER_DATA]` 파라메터로 전달됩니다. 

- ***NAS 서버에서 적립금 관리 시 사용***
    > `USER_DATA`에 `초기화 함수` 호출 시 사용한 `userId`를 입력합니다.

```
[NASWall openWallWithUserData:@"USER_DATA"];
```

***타겟팅 광고 노출 방법***
    
기본적으로 오퍼월에는 타겟팅 광고는 노출되지 않습니다.
사용자의 `연령` 또는 `성별` 정보가 있는 경우, 아래와 같은 방법으로 타겟팅 광고를 노출시킬 수 있습니다.

```
int age = 20; // 연령 (연령 정보가 없을 경우 0 으로 설정)
NAS_WALL_SEX sex = NAS_WALL_SEX_MALE; // 성별 (NAS_WALL_SEX_UNKNOWN=성별정보없음, NAS_WALL_SEX_MALE=남자, NAS_WALL_SEX_FEMALE=여자)
[NASWall openWallWithUserData:@"USER_DATA" age:age sex:sex];
```

### `임베드 오퍼월 삽입`
오퍼월을 **특정 View** 내에 보여주고자 하는 경우 사용합니다.

- ***개발자 서버에서 적립금 관리 시 사용***
    > `PARENT`에 임베드 오퍼월을 삽입하고자 하는 `View(UIView)`를 입력합니다.
    >
    > `USER_DATA`에 개발자가 사용자를 구분하기 위한 값을 입력합니다. 광고 참여 완료 후 개발자 서버로 `콜백 URL` 호출 시. `[USER_DATA]` 파라메터로 전달됩니다. 

- ***NAS 서버에서 적립금 관리 시 사용***
    > `PARENT`에 임베드 오퍼월을 삽입하고자 하는 `View(UIView)`를 입력합니다.
    >
    > `USER_DATA`에 `초기화 함수` 호출 시 사용한 `userId`를 입력합니다.

```
[NASWall embedWallWithParent:PARENT userData:@"USER_DATA"];
```

***타겟팅 광고 노출 방법***
    
기본적으로 오퍼월에는 타겟팅 광고는 노출되지 않습니다.
사용자의 `연령` 또는 `성별` 정보가 있는 경우, 아래와 같은 방법으로 타겟팅 광고를 노출시킬 수 있습니다.

```
int age = 20; // 연령 (연령 정보가 없을 경우 0 으로 설정)
NAS_WALL_SEX sex = NAS_WALL_SEX_MALE; // 성별 (NAS_WALL_SEX_UNKNOWN=성별정보없음, NAS_WALL_SEX_MALE=남자, NAS_WALL_SEX_FEMALE=여자)
[NASWall embedWallWithParent:PARENT userData:@"USER_DATA" age:age sex:sex];
```

### `적립금 조회` _(NAS 서버에서 적립금 관리 시 사용)_
NASWall 클래스의 `getUserPoint` 함수를 호출하여 사용자 적립금을 조회할 수 있습니다.

성공 시 `NASWallGetUserPointSuccess` 이벤트가 발생합니다.<br/>
실패 시 `NASWallGetUserPointError` 이벤트가 발생합니다.

```
[NASWall getUserPoint];
```

### `적립금 사용 (아이템 구매)` _(NAS 서버에서 적립금 관리 시 사용)_
NASWall 클래스의 `purchaseItem:(NSString*)itemId` 함수를 호출하여 아이템을 구매하고 사용자 적립금을 사용할 수 있습니다.

`purchaseItem:(NSString*)itemId count:(int)count` 함수를 사용하면 구매 수량을 지정하여 구매할 수 있습니다.

성공 시 `NASWallPurchaseItemSuccess` 이벤트가 발생합니다.<br/>
실패 시 `NASWallPurchaseItemError` 이벤트가 발생합니다.<br/>
적립금 부족 시 `NASWallPurchaseItemNotEnoughPoint` 이벤트가 발생합니다.

```
[NASWall purchaseItem:itemId];
```

### `이벤트` _(공통)_
SDK 초기화 시 `delegate` 에 지정한 객체로 아래의 이벤트가 전달됩니다.

- #### 오퍼월 종료 (NASWallClose)
    사용자가 사용자가 닫기 버튼을 눌러서 오퍼월이 닫혔을 때 발생하는 이벤트
    ```
    - (void)NASWallClose;
    ```
  
### `이벤트` _(NAS 서버에서 적립금 관리 시 사용)_
이 이벤트는 NAS 서버에서 적립금 관리 시에 사용하는 이벤트입니다.

- #### 적립금 조회 성공 (NASWallGetUserPointSuccess)
    적립금 조회가 성공했을 때 발생하는 이벤트
    - `point` : 적립 금액
    - `unit` : 적립 금액 단위
    ```
    - (void)NASWallGetUserPointSuccess:(int)point unit:(NSString*)unit;
    ```
    
- #### 적립금 조회 실패 (NASWallGetUserPointError)
    적립금 조회가 실패했을 때 발생하는 이벤트
    - `errorCode` : 오류 코드
        - `-10` : 잘못된 앱 KEY<br/>
        - `-100` :  개발자 서버에서 적립금을 관리하는 경우는 사용할 수 없음<br/>
        - `그외` : 기타 오류
    ```
    - (void)NASWallGetUserPointError:(int)errorCode;
    ```

- #### 아이템 구매 성공 (NASWallPurchaseItemSuccess)
    아이템 구매가 성공했을 때 발생하는 이벤트
    - `itemId` : 구매 아이템 ID
    - `count` : 구매 수량
    - `point` : 구매 후 남은 적립 금액
    - `unit` : 적립 금액 단위
    ```
    - (void)NASWallPurchaseItemSuccess:(NSString*)itemId count:(int)count point:(int)point unit:(NSString*)unit;
    ```

- #### 아이템 구매 적립금 부족 (NASWallPurchaseItemNotEnoughPoint)
    아이템 구매 시 적립금이 부족할 때 발생하는 이벤트
    - `itemId` : 구매 아이템 ID
    - `count` : 구매 수량
    ```
    - (void)NASWallPurchaseItemNotEnoughPoint:(NSString*)itemId count:(int)count;
    ```
    
- #### 아이템 구매 실패 (NASWallPurchaseItemError)
    아이템 구매가 실패했을 때 발생하는 이벤트입니다.
    - `errorCode` : 오류 코드
        - `-10` : 잘못된 앱 KEY<br/>
        - `-11` : 잘못된 아이템 ID<br/>
        - `-12` : 잘못된 구매 수량<br/>
        - `그외` : 기타 오류
    ```
    - (void)NASWallPurchaseItemError:(NSString*)itemId count:(int)count errorCode:(int)errorCode;
    ```
