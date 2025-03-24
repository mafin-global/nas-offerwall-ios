import NasWallKit
import SwiftUI

struct ContentView: View {
    // MARK: - Environment
    
    @Environment(\.colorScheme) private var envColorScheme
    
    // MARK: - Variable
    
    /// NasWallKit - 초기화
    @StateObject private var nwkInitialize = NasWallKit_Initialize()
    /// NasWallKit - 획득 가능 총 적립금
    @StateObject private var nwkTotalPoint = NasWallKit_TotalPoint()
    /// NasWallKit - 보유 적립금
    @StateObject private var nwkUserPoint = NasWallKit_UserPoint()
    
    /// 테마
    @State private var colorScheme: ColorScheme?
    // 설정 정보 펼침 여부
    @State private var isSettingsExpanded = isPreview
    
    // MARK: - Function
    
    /// NAS SDK 초기화
    private func nasWallKitInitialize() {
        nwkInitialize.loadData { error in
            if error == nil {
                lls("NAS SDK 초기화 성공")
                loadTotalPoint()
                loadUserPoint()
            } else {
                lle("NAS SDK 초기화 실패", error: error!)
            }
        }
    }
    
    /// 획득 가능 총 적립금 조회
    private func loadTotalPoint() {
        nwkTotalPoint.loadData(animation: .default)
    }
    
    /// 팝업 오퍼월 열기
    private func openPopupOfferWall() {
        NasWall.openPopupOfferWall { error in
            if error == nil {
                lls("NasWall.openPopupOfferWall() 성공")
            } else {
                lle("NasWall.openPopupOfferWall() 실패", error: error!)
            }
        } closeHandler: {
            lli("팝업 오퍼월 종료")
        }
    }
    
    /// 문의하기 열기
    private func openCs() {
        NasWall.openCs { error in
            if error == nil {
                lls("NasWall.openCs() 성공")
            } else {
                lle("NasWall.openCs() 실패", error: error!)
            }
        } closeHandler: {
            lli("문의하기 종료")
        }
    }
    
    /// 회원 적립금 조회
    private func loadUserPoint() {
        if NasWallKit_Env.serverType == .nas {
            nwkUserPoint.loadData(animation: .default)
        }
    }
    
    // MARK: - body
    
    /// Body View
    var body: some View {
        let navigationView = NavigationView {
            List {
                // 설정 정보
                DisclosureGroup(isExpanded: $isSettingsExpanded) {
                    SettingsListItem(title: "앱 KEY", value: NasWallKit_Env.appKey)
                    SettingsListItem(title: "적립금 관리 서버", value: NasWallKit_Env.serverType == .developer ? "개발자 서버" : "NAS 서버")
                    SettingsListItem(title: "회원 데이터", value: NasWallKit_Env.userData)
                    
                    if NasWallKit_Env.serverType == .nas {
                        // NAS 서버에서 적립금 관리하는 경우 회원 ID 표시
                        SettingsListItem(title: "회원 ID", value: NasWallKit_Env.userId)
                    }
                } label: {
                    Label("설정 정보 (\(NasWallKit_Env.testMode ? "테스트 모드" : "라이브 모드"))", systemImage: "gearshape.fill")
                        .labelStyle(ListLabelStyle(color: .gray.opacity(0.7)))
                }
                
                // 초기화 상태 별 UI
                switch nwkInitialize.status {
                case .idle, .loading: // 초기화 중
                    Section {
                        VStack {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                case .fail: // 초기화 실패
                    Section {
                        VStack {
                            ErrorRetry("NasWallKit 초기화 실패", error: nwkInitialize.error, showSecretMsg: true)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                case .success: // 초기화 성공
                    // 획득 가능 총 적립금
                    Section {
                        ListValue("획득 가능 총 적립금", icon: "wonsign", color: .cyan) {
                            switch nwkTotalPoint.status {
                            case .idle, .loading:
                                ProgressView()
                            case .fail:
                                Button("재시도") { loadTotalPoint() }
                            case .success:
                                if let data = nwkTotalPoint.data {
                                    Text(data.stringValue)
                                        .font(.subheadline)
                                        .foregroundColor(.primary.opacity(0.7))
                                }
                            }
                        }
                    }
                    
                    // 내장 UI
                    Section(header: Text("내장 UI")) {
                        ListButton("팝업 오퍼월", icon: "window.shade.closed", color: .blue) {
                            openPopupOfferWall()
                        }
                        
                        ListLink("임베드 오퍼월", icon: "lightswitch.on", color: .blue) {
                            EmbedOfferWallView()
                        }
                    }
                    
                    // 개발자 정의 UI
                    Section(header: Text("개발자 정의 UI")) {
                        ListLink("개발자 정의 UI 오퍼월", icon: "pencil.line", color: .blue) {
                            CustomOfferWallView()
                        }
                        
                        ListButton("문의하기", icon: "questionmark", color: .blue) {
                            openCs()
                        }
                    }
                    
                    // NAS 서버에서 적립금 관리하는 경우에 "보유 적립금"와 "아이템 구입" 표시
                    if NasWallKit_Env.serverType == .nas {
                        Section(header: Text("적립금")) {
                            ListValue("보유 적립금", icon: "wonsign", color: .purple.opacity(0.7)) {
                                switch nwkUserPoint.status {
                                case .idle, .loading:
                                    ProgressView()
                                case .fail:
                                    Button("재시도") { loadUserPoint() }
                                case .success:
                                    if let data = nwkUserPoint.data {
                                        Text(data.stringValue)
                                            .font(.subheadline)
                                            .foregroundColor(.primary.opacity(0.7))
                                    }
                                }
                            }
                            
                            ListLink("아이템 구입", icon: "cart", color: .purple) {
                                PurchaseItemView()
                                    .environmentObject(nwkUserPoint)
                            }
                        }
                    }
                }
            }
            .navigationTitle("NAS 오퍼월 SDK")
            .navigationBarTitleDisplayMode(.inline)
            // 네비게이션바 좌측 테마 변경 버튼
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("테마 변경", systemImage: "circle.lefthalf.filled") {
                        if colorScheme == nil {
                            colorScheme = envColorScheme == .dark ? .light : .dark
                        } else {
                            colorScheme = colorScheme == .dark ? .light : .dark
                        }
                    }
                }
            }
        }
        // 네비게이션뷰의 테마 설정
            .colorScheme(colorScheme ?? envColorScheme)
            .onAppear {
                // NasWallKit 초기화
                nasWallKitInitialize()
                
                // NasWallKit 테마 설정
                NasWall.theme(envColorScheme == .dark ? .dark : .light)
            }
        
        // 테마 변경 시 NasWallKit 테마 설정
        if #available(iOS 17, *) {
            navigationView.onChange(of: colorScheme) { _, newValue in
                NasWall.theme((newValue ?? envColorScheme) == .dark ? .dark : .light)
            }
        } else {
            navigationView.onChange(of: colorScheme) { newValue in
                NasWall.theme((newValue ?? envColorScheme) == .dark ? .dark : .light)
            }
        }
    }
    
    // MARK: -
    
    /// 설정 정보 목록 아이템
    struct SettingsListItem: View {
        var title: String
        var value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    // 필요 시 Preview 전용 데이터 로드 지연 시간(초) 지정을 설정합니다.
    NasWall.debugPreviewDataDelaySeconds(0)
    // 필요 시 true 로 설정 - Preview 전용 데이터 로드 시 강제로 실패 처리 할지 여부를 설정합니다.
    NasWall.debugPreviewDataForceFail(false)
    
    return ContentView()
}
