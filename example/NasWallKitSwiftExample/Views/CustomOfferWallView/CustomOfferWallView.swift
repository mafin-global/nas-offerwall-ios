//
// 개발자 정의 UI 오퍼월 - 메인 화면
//

import NasWallKit
import SwiftUI

/// 개발자 정의 UI 환경 값을 구성하기 위한 View
struct CustomOfferWallView: View {
    // MARK: - State Variant

    /// NasWallKit - 광고 목록
    @StateObject private var nwkAdList = NasWallKit_AdList()
    /// 개발자 정의 UI 공통 정보
    @StateObject private var env = CustomOfferWallView_Environment()

    // MARK: - body

    var body: some View {
        VStack {
            CustomOfferWallContentView()
                .environmentObject(nwkAdList)
                .environmentObject(env)
        }
        .onDisappear {
            nwkAdList.cleanup()
        }
    }
}

// MARK: - CustomOfferWallContentView

/// 개발자 정의 UI 메인 View
struct CustomOfferWallContentView: View {
    // MARK: - Environment

    /// NasWallKit - 광고 목록
    @EnvironmentObject private var nwkAdList: NasWallKit_AdList
    /// 개발자 정의 UI 환경 값
    @EnvironmentObject private var env: CustomOfferWallView_Environment

    // MARK: - Function

    /// 광고 목록 조회 - `listType`을 지정하지 않으면, 마지막 조회한 `listType` 사용
    private func loadAdList(_ listType: NasWallAdListType? = nil) {
        let finalListType: NasWallAdListType = listType ?? env.listType

        // "참여적립" 광고 목록 조회 시 "전체" 카테고리로 변경
        if finalListType == .basic {
            env.category = 0
        }
        nwkAdList.loadData(finalListType, animation: .default)
    }

    /// 문의하기 열기
    private func openCs() {
        NasWall.openCs { error in
            if error != nil {
                lle(error!)
            } else {
                lls("NasWall.openCs() 성공")
            }
        } closeHandler: {
            lli("문의하기 종료")
        }
    }

    // MARK: - body

    var body: some View {
        VStack {
            // 광고 목록 구분 (참여적립, 쇼핑적립, 퀴즈적립)
            let adListTypePicker = Picker("광고 목록 구분", selection: $env.listType) {
                Text("참여적립").tag(NasWallAdListType.basic)
                Text("쇼핑적립").tag(NasWallAdListType.cps)
                Text("퀴즈적립").tag(NasWallAdListType.cpq)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 5)
            .padding(.bottom, 5)
            // 광고 목록 조회 중이면 disable 처리
            .disabled(nwkAdList.status == .loading)

            // 광고 목록 구분 변경 시 광고 목록 조회
            if #available(iOS 17, *) {
                adListTypePicker.onChange(of: env.listType) { _, newValue in
                    loadAdList(newValue)
                }
            } else {
                adListTypePicker.onChange(of: env.listType) { newValue in
                    loadAdList(newValue)
                }
            }

            // 광고 목록
            VStack {
                CustomOfferWallView_AdList()
            }
            .frame(maxHeight: .infinity)
        }
        .navigationTitle("개발자 정의 UI 오퍼월")
        .navigationBarTitleDisplayMode(.inline)
        // 네비게이션바 우측 문의하기 버튼
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("문의하기", systemImage: "questionmark.circle.fill", action: openCs)
            }
        }
        .onAppear {
            // 광고 목록 조회
            loadAdList()
        }
    }
}

// MARK: - Preview

#Preview {
    // 필요 시 초 지정 - Preview 전용 데이터 로드 시 지연 시간(초) 지정을 설정합니다.
    NasWall.debugPreviewDataDelaySeconds(0)
    // 필요 시 true 로 설정 - Preview 전용 데이터 로드 시 강제로 실패 처리 할지 여부를 설정합니다.
    NasWall.debugPreviewDataForceFail(false)

    return PreviewNavigationView("CustomOfferWallView") {
        PreviewNasWallInitView {
            CustomOfferWallView()
        }
    }
}
