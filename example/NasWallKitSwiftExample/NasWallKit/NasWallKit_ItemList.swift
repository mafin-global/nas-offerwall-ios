import NasWallKit
import SwiftUI

/// 아이템 목록 조회 - NasWallKit 연동
class NasWallKit_ItemList: NasWallKit_Base<NasWallItemList> {
    func loadData(_ animation: Animation? = nil, handler: (@MainActor (_ error: NSError?) -> Void)? = nil) {
        loading(animation: animation)

        NasWall.itemList { data, error in
            guard error == nil else {
                self.fail(error!, animation: animation, handler: handler)
                return
            }

            self.success(data, animation: animation, handler: handler)
        }
    }
}
