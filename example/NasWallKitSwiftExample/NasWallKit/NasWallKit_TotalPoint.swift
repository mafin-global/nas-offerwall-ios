import NasWallKit
import SwiftUI

/// 획득 가능 총 적립금 조회 - NasWallKit 연동
class NasWallKit_TotalPoint: NasWallKit_Base<NasWallPointInfo> {
    func loadData(animation: Animation? = nil, handler: (@MainActor (_ error: NSError?) -> Void)? = nil) {
        loading(animation: animation)

        NasWall.totalPoint { data, error in
            guard error == nil else {
                self.fail(error!, animation: animation, handler: handler)
                return
            }

            self.success(data, animation: animation, handler: handler)
        }
    }
}
