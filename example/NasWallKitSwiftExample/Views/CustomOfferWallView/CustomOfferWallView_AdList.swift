///
/// 개발자 정의 UI 오퍼월 - 광고 목록
///

import NasWallKit
import SwiftUI

struct CustomOfferWallView_AdList: View {
    // MARK: - Environment

    // 테마
    @Environment(\.colorScheme) private var colorScheme
    // NasWallKit - 광고 목록 조회
    @EnvironmentObject private var nwkAdList: NasWallKit_AdList
    // 개발자 정의 UI 환경 값
    @EnvironmentObject private var env: CustomOfferWallView_Environment

    // MARK: - Variable

    /// 카테고리 별 필터링 된 광고 목록
    @State private var filteredAdList: NasWallAdList = []
    /// 앱이 Background로 내려갔는지 여부
    @State private var isBackground: Bool = false

    /// 알림 센터 - 앱의 Background/Foreground 상태 변경 감지를 위해
    private var notificationCenter: NotificationCenter = .default

    // MARK: - Function

    /// 카테고리 별 광고 목록 필터링
    private func updateFilteredList() {
        withAnimation {
            // 조회 상태가 성공이고, 광고 목록 데이터가 있는지 검사
            guard nwkAdList.status == .success,
                  let adList = nwkAdList.data
            else {
                filteredAdList = []
                return
            }

            // 광고 목록 구분이 "참여적립" 이고 카테고리가 "전체"가 아닌 경우에 필터링 실행
            if nwkAdList.listType == .basic && env.category > 0 {
                filteredAdList = adList.filter { item in
                    item.category.rawValue == env.category
                }
            } else {
                filteredAdList = adList
            }
        }
    }

    /// 광고 목록 조회
    private func loadAdList() {
        nwkAdList.loadData(env.listType)
    }

    // MARK: - Body

    var body: some View {
        let zstack = ZStack {
            VStack {
                // 광고 목록 조회 상태 별 UI
                switch nwkAdList.status {
                case .fail: // 광고 목록 조회 실패
                    ErrorRetry("정보를 불러올 수 없습니다.", error: nwkAdList.error, action: loadAdList)

                case .idle, .loading, .success: // 광고 목록 조회 중 또는 성공
                    if let adList = nwkAdList.data {
                        if adList.isEmpty {
                            NoDataView("참여 가능한 항목이 없습니다.")
                        } else {
                            List {
                                // 광고 목록 구분이 "참여적립" 일 경우 카테고리 표시
                                if nwkAdList.listType == .basic {
                                    HStack {
                                        CustomOfferWallView_Category()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 5)
                                    .listRowSeparator(.hidden)
                                }

                                // 광고 목록 표시
                                ForEach(filteredAdList) { adInfo in
                                    CustomOfferWallView_AdListItem(adInfo)
                                        .onTapGesture {
                                            // 광고 아이템 클릭 시 상세 정보 화면 표시
                                            env.showAdDetail(adInfo)
                                        }
                                }
                                .listRowInsets(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            }

            // 광고가 목록이 이미 표시된 상태에서 다시 조회 시 광고 목록 위에 ProgressView를 보여주기 위한 코드
            if nwkAdList.status == .loading {
                if nwkAdList.data == nil {
                    // 처음 조회하는 경우, 기본 ProgressView 표시
                    ProgressView()
                } else {
                    // 다시 조회하는 경우, 광고 목록 위에 LoadingView 표시
                    VStack {
                        LoadingView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                }
            }
        }
        // 광고 상세 화면 (전체 화면)
        .fullScreenCover(isPresented: $env.isShowingAdDetail) {
            CustomOfferWallView_AdDetail()
                .environment(\.colorScheme, colorScheme)
        }
        .onAppear {
            // 앱의 Background 전환 시 알림 등록
            notificationCenter.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
                self.isBackground = true
            }
            // 앱의 Active 전환 시 알림 등록
            notificationCenter.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                if self.isBackground {
                    self.isBackground = false
                    self.nwkAdList.loadData(.basic)
                }
            }

            // 광고 목록 필터링 실행
            updateFilteredList()
        }
        .onDisappear {
            // 알림 삭제
            notificationCenter.removeObserver(self)
        }

        if #available(iOS 17, *) {
            // 광고 목록 변경 시 필터링 실행
            zstack.onChange(of: nwkAdList.data) {
                updateFilteredList()
            }
            // 카테고리 변경 시 필터링 실행
            .onChange(of: env.category) {
                updateFilteredList()
            }
        } else {
            // 광고 목록 변경 시 필터링 실행
            zstack.onChange(of: nwkAdList.data) { _ in
                updateFilteredList()
            }
            // 카테고리 변경 시 필터링 실행
            .onChange(of: env.category) { _ in
                updateFilteredList()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    // 필요 시 초 지정 - Preview 전용 데이터 로드 시 지연 시간(초) 지정을 설정합니다.
    NasWall.debugPreviewDataDelaySeconds(0)
    // 필요 시 true 로 설정 - Preview 전용 데이터 로드 시 강제로 실패 처리 할지 여부를 설정합니다.
    NasWall.debugPreviewDataForceFail(false)

    /// NasWallKit - 광고 목록 조회
    let nwkAdList = NasWallKit_AdList()
    /// 개발자 정의 UI 환경 값
    let env = CustomOfferWallView_Environment()

    return PreviewNavigationView("CustomOfferWallView_AdList") {
        PreviewNasWallInitView {
            CustomOfferWallView_AdList()
                .environmentObject(nwkAdList)
                .environmentObject(env)
                .onAppear {
                    nwkAdList.loadData(env.listType)
                }
        }
    }
}
