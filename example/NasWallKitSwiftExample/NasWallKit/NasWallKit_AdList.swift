import NasWallKit
import SwiftUI

/// 광고 목록 조회 - NasWallKit 연동
class NasWallKit_AdList: NasWallKit_Base<NasWallAdList> {
    // MARK: - Variable

    @Published var listType: NasWallAdListType?

    // MARK: - Function

    func loadData(_ listType: NasWallAdListType, animation: Animation? = nil, handler: (@MainActor (NSError?) -> Void)? = nil) {
        loading(animation: animation)

        NasWall.adList(listType) { data, error in
            self.listType = listType

            guard error == nil else {
                self.fail(error!, animation: animation, handler: handler)
                return
            }

            self.success(data, animation: animation, handler: handler)
        }
    }
}
