import NasWallKit
import SwiftUI

/// 초기화 - NasWallKit 연동
class NasWallKit_Initialize: NasWallKit_Base<Any?> {
    func loadData(_ animation: Animation? = nil, handler: (@MainActor (NSError?) -> Void)? = nil) {
        loading(animation: animation)

        switch NasWallKit_Env.shared.serverType {
        case .developer:
            NasWall.initialize(NasWallKit_Env.shared.appKey, userData: NasWallKit_Env.shared.userData, testMode: NasWallKit_Env.shared.testMode) { error in
                guard error == nil else {
                    self.fail(error!, animation: animation, handler: handler)
                    return
                }

                self.success(nil, animation: animation, handler: handler)
            }
        case .nas:
            NasWall.initialize(NasWallKit_Env.shared.appKey, userId: NasWallKit_Env.shared.userId, testMode: NasWallKit_Env.shared.testMode) { error in
                guard error == nil else {
                    self.fail(error!, animation: animation, handler: handler)
                    return
                }

                self.success(nil, animation: animation, handler: handler)
            }
        }
    }
}
