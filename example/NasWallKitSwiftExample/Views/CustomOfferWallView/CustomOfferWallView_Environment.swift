///
/// 개발자 정의 UI 오퍼월 - Environment
///

import NasWallKit
import SwiftUI

class CustomOfferWallView_Environment: ObservableObject {
    // MARK: - Variable

    /// 광고 목록 구분
    @Published var listType: NasWallAdListType = .basic
    /// 광고 카테고리
    @Published var category: Int = 0
    /// 광고 상세 정보 표시 여부
    @Published var isShowingAdDetail: Bool = false
    /// 선택된 광고 정보 (광고 상세 정보 화면에서 사용)
    @Published var selectedAdInfo: NasWallAdInfo?

    // MARK: - init

    init(listType: NasWallAdListType = .basic, category: Int = 0, isShowingAdDetail: Bool = false, selectedAdInfo: NasWallAdInfo? = nil) {
        self.listType = listType
        self.category = category
        self.isShowingAdDetail = isShowingAdDetail
        self.selectedAdInfo = selectedAdInfo
    }

    // MARK: - Function

    /// 광고 상세 화면 표시
    func showAdDetail(_ adInfo: NasWallAdInfo) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            isShowingAdDetail = true
            selectedAdInfo = adInfo
        }
    }

    /// 광고 상세 화면 닫기
    func closeAdDetail() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            isShowingAdDetail = false
            selectedAdInfo = nil
        }
    }
}
