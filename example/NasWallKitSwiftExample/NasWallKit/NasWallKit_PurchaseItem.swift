import NasWallKit
import SwiftUI

/// 아이템 구입 - NasWallKit 연동
class NasWallKit_PurchaseItem: NasWallKit_Base<NasWallPointInfo> {
    func loadData(_ itemId: Int, qty: Int, animation: Animation? = nil, handler: (@MainActor (NSError?) -> Void)? = nil) {
        loading(animation: animation)

        NasWall.purchaseItem(itemId, qty: qty) { data, error in
            guard error == nil else {
                self.fail(error!, animation: animation, handler: handler)
                return
            }

            self.success(data, animation: animation, handler: handler)
        }
    }
}
