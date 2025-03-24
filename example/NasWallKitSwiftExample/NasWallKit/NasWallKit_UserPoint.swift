import NasWallKit
import SwiftUI

/// 회원 적립금 조회 - NasWallKit 연동
class NasWallKit_UserPoint: NasWallKit_Base<NasWallPointInfo> {
    func loadData(animation: Animation? = nil, handler: (@MainActor (_ error: NSError?) -> Void)? = nil) {
        loading(animation: animation)

        NasWall.userPoint { data, error in
            guard error == nil else {
                self.fail(error!, animation: animation, handler: handler)
                return
            }

            self.success(data, animation: animation, handler: handler)
        }
    }
}
