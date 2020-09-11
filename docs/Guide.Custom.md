# 📖 NAS 오퍼월 iOS SDK - 개발자 정의 UI 개발 가이드
이 문서는 NAS 오퍼월 SDK 개발자 정의 UI 연동 가이드를 제공합니다.

오퍼월 UI 표시 방식은 다음 두가지를 지원합니다.

- `내장 UI` : 미리 만들어진 UI를 사용하는 방식으로, 별도의 UI 개발 없이 쉽게 연동할 수 있습니다.
- `개발자 정의 UI` : 개발자가 UI를 직접 만들어서 연동할 수 있는 방식으로, 개발자 앱의 UI에 맞게 자유롭게 구성할 수 있습니다.

`내장 UI`를 사용 하려면, [📖 내장 UI 개발 가이드](Guide.Embed.md) 문서를 참고해 주시기 랍니다.

## 📝 업데이트
- [`2020년 3월 31일`](Update.md#2020년-3월-31일)
    - 통신 관련 버그 수정
- [`2020년 1월 30일`](Update.md#2020년-1월-30일---내장-ui) - _내장 UI_
    - foreground 시 새로고침되지 않는 버그 수정
- [`2020년 1월 28일`](Update.md#2020년-1월-28일---내장-ui) - _내장 UI_
    - 환경에 따라 오퍼월이 보이지 않는 현상 수정
- [전체 업데이트 목록 보기](Update.md)

## 주의사항
`개발자 정의 UI` 사용 시,
`잠금화면`, `앱의 홈 화면` 에서 [`광고 목록 가져오기 API`](#광고-목록-가져오기)를 호출해서는 안됩니다.

이 화면에서 [`광고 목록 가져오기 API`](#광고-목록-가져오기) 사용 시, 과중한 API 호출로 인해 서버에 많은 부하가 발생합니다.

이런 경우, 광고 목록이 `차단` 당할 수 있으니 주의해 주시기 바랍니다.

## 개발자 등록
NAS 오퍼월 연동을 위해서는 먼저 개발자 등록을 해야합니다.

[NAS 홈페이지](http://www.appang.kr/nas) 에 접속하여 `회원가입` 버튼을 눌러 가입합니다.

## 매체 등록
NAS 오퍼월 연동을 위해서는 연동할 매체 등록 해야합니다.

[NAS 홈페이지](http://www.appang.kr/nas) 에 로그인 후 `신규매체 등록` 버튼을 눌러 매체를 등록합니다.

매체를 등록하면 32자리 `앱 KEY`가 발급되며, SDK 초기화 시 필요한 값입니다.
`매체 관리` 메뉴에서 등록한 매체의 우측 `more` 버튼을 눌러 `앱 KEY 복사` 를 눌러 `앱 KEY`를 복사할 수 있습니다.

### `적립금 관리 서버`
사용자 적립금을 NAS 서버에서 관리할지 아니면 개발자 서버에서 관리할지를 선택합니다.

- `NAS 서버 사용` : 개발자가 서버를 가지고있지 않고, NAS 서버에서 사용자의 적립금을 관리할 경우 선택합니다. SDK를 통해 적립금의 확인 및 사용이 가능합니다.
- `개발자 서버 사용` : 개발자가 서버에서 사용자 적립금을 직접 관리할 경우 선택합니다. 사용자가 적립금 충전 시 개발자 서버의 콜백 URL로 통보해줍니다.

### `리워드 금액 단위`
리워드 금액 단위는 오퍼월 에서 사용자에게 보이는 리워드 금액의 단위입니다.

만약 광고 참여 완료 시 사용자에게 100골드를 준다면 `골드`를 입력하고, 100원을 준다면 `원`을 입력합니다

### `리워드 금액 비율`
리워드 금액 비율은 광고 참여 완료 시 개발자가 얻게되는 수익 중에서 사용자에게 리워드로 줄 금액의 비율(%)입니다.

만약 사용자가 광고참여 시 개발자가 받게되는 수익이 200원이고, 사용자에게 100원을 주고 싶으면 리워드 금액 비율을 `50`으로 입력합니다.

각 광고마다 개발자에게 지급되는 금액이 다르기 때문에, 사용자에게 지급하는 실제 금액은 `콜백 URL` 호출 시 함께 전송됩니다.

### `콜백 URL 등록` _(개발자 서버에서 적립금 관리 시 사용)_
적립금 관리 서버를 `개발자 서버 사용` 으로 선택한 경우 설정할 수 있습니다.

`콜백 URL`은 NAS 서버에서 개발자 서버로 호출하는 URL로 사용자가 광고 `참여 완료` 시 호출됩니다. `콜백 URL`에서 사용자에게 적립금등의 혜택을 지급하도록 구성하시기 바랍니다.
콜백 URL은 `앱 설정` 화면의 `보상형 기본` 탭에서 설정할 수 있습니다.

`콜백 URL`에는 아래의 값들이 제공됩니다.

이 값들은 개발자 서버로 호출 시 실제 값으로 변환됩니다. `콜백 URL` 입력 시 반드시 `대괄호`까지 입력하시기 바랍니다.

- `[SEQ_ID]` : 적립 고유 ID
- `[USER_DATA]` : 회원 정의 데이터
- `[PRICE]` : 광고 단가 (매체 수익금)
- `[REWARD]` : 리워드 금액 (오퍼월에서 참여한 경우에만 값이 있음)
- `[AD_ID]` : 광고 ID
- `[AD_KEY]` : 광고 KEY
- `[AD_NAME]` : 광고명
- `[AD_TYPE]` : 광고구분 (CPI, CPE, CPA, CPC, FACEBOOK)
- `[USER_ADID]` : 사용자 기기 36자리 광고 ID (Android : ADID, iOS : IDFA)
- `[USER_IP]` : 사용자 IP 주소

```
http://server.kr/callback.asp?sid=[SEQ_ID]&ud=[USER_DATA]&p=[PRICE]&r=[REWARD]&ai=[AD_ID]&ak=[AD_KEY]&n=[AD_NAME]&t=[AD_TYPE]&adid=[USER_ADID]&ip=[USER_IP]`
```

개발자 서버의 웹페이지가 `HTTP 200` 상태값을 리턴하면 `콜백 URL`을 더 이상 호출하지 않고 중지됩니다.
만약 `HTTP 200` 이외의 상태값이 리턴되면 `최대 5번`까지 재시도하여 호출하고, `5번` 오류가 발생하면 더 이상 호출하지 않습니다.

오류 횟수에 따른 `재호출` 시간 간격은 아래와 같습니다.

- `1회 오류 시` : 오류 시점부터 5분 후 재호출
- `2회 오류 시` : 오류 시점부터 10분 후 재호출
- `3회 오류 시` : 오류 시점부터 25분 후 재호출
- `4회 오류 시` : 오류 시점부터 30분 후 재호출
- `5회 오류 시` : 오류 시점부터 8시간 후 재호출
- `6회 오류 시` : 호출 중단

> ***적립금 중복 지급 방지를 위한 처리***
> - 콜백 중복 호출 시, 적립금 중복 지급을 방지하기 위해, `[SEQ_ID]`를 기준으로 중복지급을 막아주시기 바랍니다.
>
> - 동일 사용자에게 적립금 중복 지급을 방지하기 위해, 개발사의 `회원 ID` 와 `[AD_ID]` 값을 기준으로 중복지급을 막아주시기 바랍니다.

### `아이템 등록` _(NAS 서버에서 적립금 관리 시 사용)_
아이템은 적립금 관리 서버를 `NAS 서버 사용` 으로 선택한 경우, 사용자가 적립금을 사용(차감)할 때 필요합니다.

아이템을 등록하고 SDK의 `아이템 구매 함수`를 이용하면, 사용자의 적립금을 사용(차감)할 수 있습니다.

`매체 관리` 메뉴에서 등록한 매체의 우측 `more` 버튼을 누르고, `아이템 관리` 를 눌러 아이템 관리 창을 띄웁니다.

아이템 관리 창에서 `아이템 추가` 버튼을 눌러 아이템을 등록합니다.

- `아이템 이름` : 아이템의 이름을 입력합니다.
- `가격` : 아이템의 가격을 입력합니다. 사용자가 아이템 구매 시 입력한 가격 만큼 적립금이 차감됩니다.

아이템 등록 후 아이템 목록에서 `아이템 ID` 를 확인할 수 있습니다.
`아이템 ID`는 SDK의 `아이템 구매 함수`를 호출할 때 필요한 값입니다.
등록된 아이템 정보는 `수정` 버튼을 눌러 언제든지 변경할 수 있습니다.

## SDK 연동

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
    > - `appKey` : 앱 등록 후 받은 32자리 키를 입력합니다.
    > - `testMode` : 개발 `테스트 버전인 경우에만 YES`를 입력하고, `배포 버전에서는 NO`를 입력합니다.
    > - `userId` : 사용자를 구분하기 위한 ID입니다. NAS 서버에서 `사용자 ID` 별로 적립금이 쌓이기 때문에 사용자별로 고유한 값을 입력해야합니다.
    > - `delegate` : SDK의 `이벤트`를 받을 객체를 지정합니다.
    ```
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        [NASWall initWithAppKey:@"앱KEY" testMode:NO userId:@"사용자ID" delegate:self];
        ...
    }
    ```
 
- ***NAS 서버에서 적립금 관리 시 사용***
    > - `appKey` : 앱 등록 후 받은 32자리 키를 입력합니다.
    > - `testMode` : 개발 `테스트 버전인 경우에만 YES`를 입력하고, `배포 버전에서는 NO`를 입력합니다.
    > - `delegate` : SDK의 `이벤트`를 받을 객체를 지정합니다.
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

### `광고 목록 가져오기`
`[NASWall getAdList:userData]` 함수를 호출하여 광고 목록을 가져올 수 있습니다.

성공 시 `NASWallGetAdListSuccess` 이벤트가 발생합니다.<br/>
실패 시 `NASWallGetAdListError` 이벤트가 발생합니다.

`NASWallMustRefreshAdList` 이벤트가 발생하면 반드시 광고 목록을 다시 가져와야 합니다.

- ***개발자 서버에서 적립금 관리 시 사용***
    > `USER_DATA`에 개발자가 사용자를 구분하기 위한 값을 입력합니다. 광고 참여 완료 후 개발자 서버로 `콜백 URL` 호출 시. `[USER_DATA]` 파라메터로 전달됩니다. 

- ***NAS 서버에서 적립금 관리 시 사용***
    > `USER_DATA`에 `초기화 함수` 호출 시 사용한 `userId`를 입력합니다.
    >

```
[NASWall openWallWithUserData:@"USER_DATA"];
```

***타겟팅 광고 노출 방법***
    
기본적으로 오퍼월에는 타겟팅 광고는 노출되지 않습니다.
사용자의 `연령` 또는 `성별` 정보가 있는 경우, 아래와 같은 방법으로 타겟팅 광고를 노출시킬 수 있습니다.

```
int age = 20; // 연령 (연령 정보가 없을 경우 0 으로 설정)
NAS_WALL_SEX sex = NAS_WALL_SEX_MALE; // 성별 (NAS_WALL_SEX_UNKNOWN=성별정보없음, NAS_WALL_SEX_MALE=남자, NAS_WALL_SEX_FEMALE=여자)
[NASWall getAdList:@"USER_DATA" age:age sex:sex];
```

***CPI 광고 설치확인 문구 표시***

`CPI 광고`는 사용자의 참여 상태에 따라 `설치확인` 문구를 표시해주어야합니다.
광고 유형이 `CPI` 이고, 현재 상태가 `참여`상태인지를 체크하여 문구를 표시해줍니다.
자세한 내용은 `예제 프로그램`을 참고해주세요.

```
if (adInfo.adType == NAS_WALL_AD_TYPE_CPI && adInfo.joinStatus == NAS_WALL_JOIN_STATUS_JOIN)
{
    // 설치확인 문구 표시
}
```

### `광고 참여`
`[NASWall joinAd:adInfo]` 함수를 호출하여 광고에 참여할 수 있습니다.

`adInfo`는 광고 `목록 가져오기 함수`를 호출하여 받은 광고 정보를 사용합니다.

성공 시 `NASWallJoinAdSuccess` 이벤트가 발생합니다.<br/>
실패 시 `NASWallJoinAdError` 이벤트가 발생합니다.

```
[NASWall joinAd:adInfo];
```

### `광고 참여 URL 실행`
`[NASWall openUrl:url]` 함수를 호출하여 괌고 참여 URL을 실행할 수 있습니다.

`url`은 광고 참여 함수를 호출하여 `NASWallJoinAdSuccess` 이벤트에서 받은 url을 사용합니다.

성공 시 `NASWallOpenUrlSuccess` 이벤트가 발생합니다.<br/>
실패 시 `NASWallOpenUrlError` 이벤트가 발생합니다.

```
[NASWall openUrl:url];
```

### `광고 상세 설명글`
`[NASWall getAdDescription:adInfo]` 함수를 호출하여 광고의 상세 설명글을 가져올 수 있습니다.

`adInfo`는 `광고 목록 가져오기 함수`를 호출하여 받은 광고 정보를 사용합니다.

성공 시 `NASWallGetAdDescriptionSuccess` 이벤트가 발생합니다.<br/>
실패 시 `NASWallGetAdDescriptionError` 이벤트가 발생합니다.

```
[NASWall getAdDescription:adInfo];
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

### `이벤트 (공통)`
SDK 초기화 시 `delegate` 에 지정한 객체로 아래의 이벤트가 전달됩니다.

- #### 광고 목록 가져오기 성공 (NASWallGetAdListSuccess)
    광고 목록 가져오기가 성공했을 때 발생하는 이벤트
    > - `adList` : 광고 목록 (`NASWallAdInfo`의 배열)
    
    ```
    - (void)NASWallGetAdListSuccess:(NSArray*)adList
    {
        for (NASWallAdInfo adInfo : adList)
        {
            NSString *title = adInfo.title; //광고명
            NSString *iconUrl = adInfo.iconUrl; //아이콘 Url
            NSString *missionText = adInfo.missionText; //참여방법
            NSString *adPrice = adInfo.adPrice; //참여비용
            int rewardPrice = adInfo.rewardPrice; //적립금
            NSString *rewardUnit = adInfo.rewardUnit; //적립금단위
        }
    }
    ```

- #### 광고 목록 가져오기 실패 (NASWallGetAdListError)
    광고 목록 가져오기가 실패했을 때 발생하는 이벤트
    > - `errorCode` : 오류 코드
    >    - `-99999` : 파라메터 오류<br/>
    >    - `-30001` : 콜백 URL이 등록되지 않았음. 앱 설정에서 콜백 URL을 등록해야함. (개발자 서버에서 적립금을 관리하는 경우)<br/>
    >    - `그외` : 기타 오류
    ```
    - (void)NASWallGetAdListError:(int)errorCode
    ```

- #### 광고 참여 성공 (NASWallJoinAdSuccess)
    광고 참여에 성공했을 때 발생하는 이벤트. 광고 참여 URL을 실행해야 합니다.
    > - `adInfo` : 참여 광고 정보
    > - `url` : 광고 참여 URL
    ```
    - (void)NASWallJoinAdSuccess:(NASWallAdInfo*)adInfo url:(NSString*)url
    {
        [NASWall openUrl:url];
    }
    ```
- #### 광고 참여 실패 (NASWallJoinAdError)
    광고 참여에 실패했을 때 발생하는 이벤트
    > - `adInfo` : 참여 광고 정보
    > - `errorCode` : 오류 코드
    >   - `-11` : `NAS 서버에서 적립금 관리`하는 경우 `사용자 ID`를 지정하지 않았음 (초기화 시 사용자 ID를 지정해야함)<br/>
    >   - `-12` : `개발자 서버에서 적립금 관리`하는 경우 `사용자 ID`를 지정했음 (초기화 시 사용자 ID를 지정하지 말아야함)<br/>
    >   - `-10001` : 광고 종료됨
    >   - `-20001` : 이미 참여 완료한 광고
    >   - `-99999` : 파라메터 오류
    >   -`그외` : 기타 오류
    ```
    - (void)NASWallJoinAdError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode
    ```

- #### 광고 참여 URL 실행 성공 (NASWallOpenUrlSuccess)
    광고 참여 URL 실행에 성공 했을 때 발생하는 이벤트
    > - `url` : 광고 참여 URL
    ```
    - (void)NASWallOpenUrlSuccess:(NSString*)url
    ```
    
- #### 광고 참여 URL 실행 실패 (NASWallOpenUrlError)
    광고 참여 URL 실행에 실패했을 때 발생하는 이벤트
    > - `url` : 광고 참여 URL
    > - `errorCode` : 오류 코드
    >   - `-1` : URL을 실행할 수 없음<br/>
    >   - `그외` : 기타 오류
    ```
    - (void)NASWallOpenUrlError:(NSString*)url errorCode:(int)errorCode
    ```

- #### 광고 목록 다시 가져오기 요청 (NASWallMustRefreshAdList)
    광고 목록을 다시 가져와야 할 때 발생하는 이벤트. 이 이벤트가 발생하면 반드시 광고 목록을 다시 가져와야 합니다.
    ```
    - (void)NASWallMustRefreshAdList
    {
        [NASWall getAdList:USER_DATA];
    }
    ```
    
- #### 광고 상세 설명글 성공 (NASWallGetAdDescriptionSuccess)
    광고 참여 설명글 가져오기가 성공했을 때 발생하는 이벤트
    > - `adInfo` : 광고 정보
    > - `description` : 광고 상세 설명글
    ```
    - (void)NASWallGetAdDescriptionSuccess:(NASWallAdInfo*)adInfo description:(NSString*)description
    ```
    
- #### 광고 상세 설명글 실패 (NASWallGetAdDescriptionError)
    광고 참여 설명글 가져오기가 실패했을 때 발생하는 이벤트
    > - `adInfo` : 광고 정보
    > - `errorCode` : 오류 코드
    >   - `-1` : 없는 캠페인<br/>
    >   - `그외` : 기타 오류
    ```
    - (void)NASWallGetAdDescriptionError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode
    ```

### `이벤트 (NAS 서버에서 적립금 관리 시 사용)`
이 이벤트는 NAS 서버에서 적립금 관리 시에 사용하는 이벤트입니다.

- #### 적립금 조회 성공 (NASWallGetUserPointSuccess)
    적립금 조회가 성공했을 때 발생하는 이벤트
    > - `point` : 적립 금액
    > - `unit` : 적립 금액 단위
    ```
    - (void)NASWallGetUserPointSuccess:(int)point unit:(NSString*)unit;
    ```
    
- #### 적립금 조회 실패 (NASWallGetUserPointError)
    적립금 조회가 실패했을 때 발생하는 이벤트
    > - `errorCode` : 오류 코드
    >   - `-10` : 잘못된 앱 KEY<br/>
    >   - `-100` :  개발자 서버에서 적립금을 관리하는 경우는 사용할 수 없음<br/>
    >   - `그외` : 기타 오류
    ```
    - (void)NASWallGetUserPointError:(int)errorCode;
    ```

- #### 아이템 구매 성공 (NASWallPurchaseItemSuccess)
    아이템 구매가 성공했을 때 발생하는 이벤트
    > - `itemId` : 구매 아이템 ID
    > - `count` : 구매 수량
    > - `point` : 구매 후 남은 적립 금액
    > - `unit` : 적립 금액 단위
    ```
    - (void)NASWallPurchaseItemSuccess:(NSString*)itemId count:(int)count point:(int)point unit:(NSString*)unit;
    ```

- #### 아이템 구매 적립금 부족 (NASWallPurchaseItemNotEnoughPoint)
    아이템 구매 시 적립금이 부족할 때 발생하는 이벤트
    > - `itemId` : 구매 아이템 ID
    > - `count` : 구매 수량
    ```
    - (void)NASWallPurchaseItemNotEnoughPoint:(NSString*)itemId count:(int)count;
    ```
    
- #### 아이템 구매 실패 (NASWallPurchaseItemError)
    아이템 구매가 실패했을 때 발생하는 이벤트입니다.
    > - `errorCode` : 오류 코드
    >   - `-10` : 잘못된 앱 KEY<br/>
    >   - `-11` : 잘못된 아이템 ID<br/>
    >   - `-12` : 잘못된 구매 수량<br/>
    >   - `그외` : 기타 오류
    ```
    - (void)NASWallPurchaseItemError:(NSString*)itemId count:(int)count errorCode:(int)errorCode;
    ```
