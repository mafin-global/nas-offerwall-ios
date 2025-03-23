///
/// 개발자 정의 UI 오퍼월 - 광고 목록 아이템
///

import NasWallKit
import SwiftUI

struct CustomOfferWallView_AdListItem: View {
    // MARK: - Environment

    /// 테마
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Variable

    /// 광고 정보
    private let adInfo: NasWallAdInfo
    /// 가격 정보를 강제로 보여줄지 여부
    private let forceShowAdPrice: Bool

    // MARK: - init

    init(_ adInfo: NasWallAdInfo, forceShowAdPrice: Bool = false) {
        self.adInfo = adInfo
        self.forceShowAdPrice = forceShowAdPrice
    }

    // MARK: - body

    var body: some View {
        VStack {
            HStack {
                // 아이콘
                AdIcon(adInfo.iconUrl, size: 60)

                VStack(alignment: .leading, spacing: 5) {
                    // 광고명
                    Text(adInfo.title)
                        .font(.subheadline.weight(.semibold))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        // 광고 참여 가격이 "무료"가 아니면 가격 정보 표시
                        if adInfo.adPrice != "무료" || forceShowAdPrice {
                            Text(adInfo.adPrice)
                                .padding(.vertical, 1)
                                .padding(.horizontal, 3)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.8))
                                .background(colorScheme == .dark ? .tertiary : .secondary)
                                .cornerRadius(5)
                        }

                        // 미션 텍스트
                        Text(adInfo.missionText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                // 적립 적립금
                Text("\(adInfo.rewardPrice.formatted())\(adInfo.rewardUnit)")
                    .frame(width: 60)
                    .padding(10)
                    .background(.blue)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .cornerRadius(20)
                    .padding(.trailing, 2)
            }
            .contentShape(Rectangle())
        }
    }
}

// MARK: - Preview

#if DEBUG
    #Preview {
        PreviewNavigationView("CustomOfferWallView_AdListItem") {
            PreviewNasWallInitView {
                PreviewView()
            }
        }
    }

    private struct PreviewView: View {
        /// NasWallKit - 광고 목록 조회
        @ObservedObject private var nwkAdList = NasWallKit_AdList()

        /// 광고 목록 조회
        private func loadData() {
            nwkAdList.loadData(.basic)
        }

        var body: some View {
            VStack {
                // 광고 목록 조회 상태 별 UI
                switch nwkAdList.status {
                case .idle, .loading: // 광고 목록 조회 중
                    ProgressView()

                case .fail: // 광고 목록 조회 실패
                    ErrorRetry(nwkAdList.error, action: loadData)

                case .success: // 광고 목록 조회 성공
                    if let adList = nwkAdList.data, let adInfo = adList.first {
                        CustomOfferWallView_AdListItem(adInfo, forceShowAdPrice: true)
                            .padding()
                    }
                }
            }
            .onAppear {
                loadData()
            }
        }
    }
#endif
