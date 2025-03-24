import NasWallKit
import SwiftUI

/// 초기화 - NasWallKit 연동
class NasWallKit_Initialize: NasWallKit_Base<Any?> {
    func loadData(_ animation: Animation? = nil, handler: (@MainActor (_ error: NSError?) -> Void)? = nil) {
        loading(animation: animation)
        
        switch NasWallKit_Env.serverType {
        case .developer:
            NasWall.initialize(NasWallKit_Env.appKey, userData: NasWallKit_Env.userData, testMode: NasWallKit_Env.testMode) { error in
                guard error == nil else {
                    self.fail(error!, animation: animation, handler: handler)
                    return
                }
                
                self.success(nil, animation: animation, handler: handler)
            }
        case .nas:
            NasWall.initialize(NasWallKit_Env.appKey, userId: NasWallKit_Env.userId, testMode: NasWallKit_Env.testMode) { error in
                guard error == nil else {
                    self.fail(error!, animation: animation, handler: handler)
                    return
                }
                
                self.success(nil, animation: animation, handler: handler)
            }
        }
    }
}
