import NasWallKit
import SwiftUI

/// 광고 참여 - NasWallKit 연동
class NasWallKit_JoinAd: NasWallKit_Base<Any?> {
    func loadData(_ adInfo: NasWallAdInfo, animation: Animation? = nil, handler: (@MainActor (NSError?) -> Void)? = nil) {
        loading(animation: animation)

        NasWall.joinAd(adInfo) { error in
            guard error == nil else {
                self.fail(error!, animation: animation, handler: handler)
                return
            }

            self.success(nil, animation: animation, handler: handler)
        }
    }
}
