//
// 개발자 정의 UI 오퍼월 - 광고 상세 화면
//

import NasWallKit
import SwiftUI

/// 광고 상세 화면 `View`
struct CustomOfferWallView_AdDetail: View {
    // MARK: - Environment

    /// 테마
    @Environment(\.colorScheme) private var colorScheme
    /// 개발자 정의 UI 환경 값
    @EnvironmentObject private var env: CustomOfferWallView_Environment

    // MARK: - State

    /// NasWallKit - 광고 상세 설명 조회
    @StateObject private var nwkAdDescription = NasWallKit_AdDescription()
    /// NasWallKit - 광고 참여
    @StateObject private var nwkJoinAd = NasWallKit_JoinAd()
    /// 참여 오류 얼럿 표시 여부
    @State private var showJoinErrorAlert: Bool = false

    // MARK: - Function

    /// 광고 상세 설명 조회
    private func loadDescription() {
        guard let adInfo = env.selectedAdInfo else {
            return
        }
        nwkAdDescription.loadData(adInfo, animation: .default)
    }

    /// 광고 참여하기
    private func joinAd() {
        guard let adInfo = env.selectedAdInfo else {
            return
        }
        nwkJoinAd.loadData(adInfo, animation: .default) { error in
            if error != nil {
                // 광고 참여 실패 시 얼럿 표시
                showJoinErrorAlert = true
            } else {
                // 광고 참여 성공. 종료
                env.isShowingAdDetail = false
            }
        }
    }

    // MARK: - body

    var body: some View {
        ModalView("참여하기") {
            if let info = env.selectedAdInfo {
                // 상단 광고 정보
                HStack {
                    // 아이콘
                    AdIcon(info.iconUrl)

                    VStack(alignment: .leading, spacing: 1) {
                        // 제목
                        Text(info.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)

                        // 미션 텍스트
                        Text(info.missionText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        // 적립 적립금
                        Text("\(info.rewardPrice)\(info.rewardUnit) 적립")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.blue)
                    }

                    Spacer()
                }
                .padding(10)
                .background(Color(UIColor.tertiarySystemBackground))

                // 광고 상세 설명
                VStack {
                    // 광고 상세 설명 조회 상태 별 UI
                    switch nwkAdDescription.status {
                    case .idle, .loading: // 광고 상세 설명 조회 중
                        ProgressView()

                    case .fail: // 광고 상세 설명 조회 실패
                        ErrorRetry("정보를 불러올 수 없습니다.", error: nwkAdDescription.error, action: loadDescription)

                    case .success: // 광고 상세 설명 조회 성공
                        ScrollView {
                            Text(nwkAdDescription.data!)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.subheadline)
                                .foregroundStyle(.primary.opacity(0.7))
                                .padding(16)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.secondarySystemBackground))

                if nwkAdDescription.status == .success {
                    // 참여하기 버튼
                    MyButton("참여하기", loading: nwkJoinAd.status == .loading, action: joinAd)
                        .transition(.move(edge: .bottom))
                        .padding(10)
                        .background(Color(UIColor.tertiarySystemBackground))
                } else if nwkAdDescription.status == .fail {
                    // 닫기 버튼
                    MyButton("닫기", action: env.closeAdDetail)
                        .transition(.move(edge: .bottom))
                        .padding(10)
                        .background(Color(UIColor.tertiarySystemBackground))
                }
            }
        }
        .titleBackgroundColor(colorScheme == .dark ? Color(red: 0.08, green: 0.08, blue: 0.08) : .blue)
        .onClose(env.closeAdDetail)
        // 참여 중이면 닫기 버튼 disable 처리
        .closeDisabled(nwkJoinAd.status == .loading)
        // 광고 참여 오류 얼럿
        .alert("참여 실패", isPresented: $showJoinErrorAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            if let error = nwkJoinAd.error {
                Text("(\(error.code)) \(error.localizedDescription)")
            } else {
                Text("참여할 수 없습니다.")
            }
        }
        .onAppear {
            if env.selectedAdInfo != nil {
                // 상세 설명 로드
                loadDescription()
            } else {
                // 광고 정보가 없으면 종료
                env.closeAdDetail()
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
    #Preview {
        // 필요 시 초 지정 - Preview 전용 데이터 로드 시 지연 시간(초) 지정을 설정합니다.
        NasWall.debugPreviewDataDelaySeconds(0)
        // 필요 시 true 로 설정 - Preview 전용 데이터 로드 시 강제로 실패 처리 할지 여부를 설정합니다.
        NasWall.debugPreviewDataForceFail(false)

        return PreviewNasWallInitView {
            PreviewView()
        }
    }

    /// Preview 상태에서 광고 목록 조회해서 첫번째 아이템을 사용
    private struct PreviewView: View {
        // MARK: - Variable

        /// NasWallKit - 광고 목록 조회
        @ObservedObject private var nwkAdList = NasWallKit_AdList()
        /// 개발자 정의 UI 환경 값
        @ObservedObject private var env = CustomOfferWallView_Environment()

        // MARK: - Function

        /// 광고 목록 조회
        private func loadAdList() {
            nwkAdList.loadData(.basic) { error in
                if error == nil, let list = nwkAdList.data, list.isEmpty == false {
                    // 첫 번째 아이템 사용
                    env.selectedAdInfo = list.first
                }
            }
        }

        // MARK: - body

        var body: some View {
            VStack {
                // 광고 목록 조회 상태 별 UI
                switch nwkAdList.status {
                case .idle, .loading: // 광고 목록 조회 중
                    ProgressView()

                case .fail: // 광고 목록 조회 실패
                    ErrorRetry("정보를 불러올 수 없습니다.", error: nwkAdList.error, action: loadAdList)

                case .success: // 광고 목록 조회 성공
                    CustomOfferWallView_AdDetail().environmentObject(env)
                }
            }
            .onAppear {
                // 광고 목록 조회
                loadAdList()
            }
        }
    }
#endif
