///
/// 개발자 정의 UI 오퍼월 - 카테고리 선택 Segment
///

import NasWallKit
import SwiftUI

struct CustomOfferWallView_Category: View {
    // MARK: - Environment

    /// NasWallKit - 광고 목록 조회
    @EnvironmentObject private var nwkAdList: NasWallKit_AdList
    /// 개발자 정의 UI 환경 값
    @EnvironmentObject private var env: CustomOfferWallView_Environment

    // MARK: - Variable

    /// 카테고리 목록
    @State private var categoryList: [NasWallAdCategory] = []

    // MARK: - Function

    /// 카테고리 목록 갱신
    private func updateCategoryList() {
        // 광고 목록 구분이 "참여적립" 이고, 광고 목록 데이터가 있는지 검사
        guard nwkAdList.listType == .basic, let adList = nwkAdList.data else {
            if categoryList.isEmpty == false {
                categoryList = []
            }
            return
        }

        var newCategoryList: [NasWallAdCategory] = []

        for adInfo in adList where !newCategoryList.contains(adInfo.category) {
            newCategoryList.append(adInfo.category)
        }

        categoryList = newCategoryList
    }

    // MARK: - body

    var body: some View {
        let vstack = VStack {
            // 광고 목록 구분이 "참여적립" 이고, 카테고리가 있으면, 세그먼트 UI 표시
            if nwkAdList.listType == .basic, categoryList.isEmpty == false {
                Picker("", selection: $env.category) {
                    Text("전체").tag(0)
                    ForEach(categoryList) { item in
                        Text(item.name).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .fixedSize()
                .disabled(nwkAdList.status == .loading)
            }
        }
        .onAppear {
            // 카테고리 목록 갱신
            updateCategoryList()
        }

        if #available(iOS 17, *) {
            // 광고 목록 데이터 변경 시 카테고리 목록 갱신
            vstack.onChange(of: nwkAdList.data) {
                updateCategoryList()
            }
            // 광고 목록 구분 변경 시 카테고리 목록 갱신
            .onChange(of: env.listType) {
                updateCategoryList()
            }
        } else {
            // 광고 목록 데이터 변경 시 카테고리 목록 갱신
            vstack.onChange(of: nwkAdList.data) { _ in
                updateCategoryList()
            }
            // 광고 목록 구분 변경 시 카테고리 목록 갱신
            .onChange(of: env.listType) { _ in
                updateCategoryList()
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
    #Preview {
        PreviewNavigationView("CustomOfferWallView_Category") {
            PreviewNasWallInitView {
                PreviewView()
            }
        }
    }

    private struct PreviewView: View {
        /// NasWallKit - 광고 목록 조회
        @ObservedObject private var nwkAdList = NasWallKit_AdList()

        /// 광고 목록 조회
        private func loadAdData() {
            nwkAdList.loadData(.basic)
        }

        var body: some View {
            VStack {
                // 광고 목록 조회 상태 별 UI
                switch nwkAdList.status {
                case .idle, .loading: // 광고 목록 조회 중
                    ProgressView()

                case .fail: // 광고 목록 조회 실패
                    ErrorRetry(nwkAdList.error, action: loadAdData)

                case .success: // 광고 목록 조회 성공
                    CustomOfferWallView_Category()
                        .environmentObject(nwkAdList)
                        .environmentObject(CustomOfferWallView_Environment())
                }
            }
            .onAppear {
                loadAdData()
            }
        }
    }
#endif
