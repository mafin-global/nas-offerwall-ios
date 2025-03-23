import NasWallKit
import SwiftUI

/// 광고 상세 설명 조회 - NasWallKit 연동
class NasWallKit_AdDescription: NasWallKit_Base<String> {
    func loadData(_ adInfo: NasWallAdInfo, animation: Animation? = nil, handler: (@MainActor (NSError?) -> Void)? = nil) {
        loading(animation: animation)

        NasWall.adDescription(adInfo) { data, error in
            guard error == nil else {
                self.fail(error!, animation: animation, handler: handler)
                return
            }

            self.success(data, animation: animation, handler: handler)
        }
    }
}
