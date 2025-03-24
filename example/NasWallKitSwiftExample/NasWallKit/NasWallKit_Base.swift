import SwiftUI

/// NasWallKit 연동 상태
enum NasWallKitStatus {
    case idle
    case loading
    case success
    case fail
}

/// NasWallKit 연동을 위한 기본 Class
class NasWallKit_Base<T>: Log, ObservableObject {
    // MARK: - Variable
    
    @Published private(set) var status: NasWallKitStatus = .idle
    @Published private(set) var error: NSError?
    @Published private(set) var data: T?
    
    // MARK: - Function
    
    /// 로딩 상태로 변경
    func loading(animation: Animation? = nil) {
        internalWithAnimation(animation) {
            self.status = .loading
            self.error = nil
        }
    }
    
    /// 성공 처리
    func success(_ data: T?, animation: Animation? = nil, functionName _: String = #function, handler: (@MainActor (_ error: NSError?) -> Void)?) {
        internalWithAnimation(animation) {
            self.status = .success
            self.error = nil
            self.data = data
            handler?(nil)
        }
    }
    
    /// 실패 처리
    func fail(_ error: NSError, animation: Animation? = nil, functionName: String = #function, handler: (@MainActor (_ error: NSError?) -> Void)?) {
        internalWithAnimation(animation) {
            self.status = .fail
            self.error = error
            self.data = nil
            self.lle(error, functionName: functionName)
            handler?(error)
        }
    }
    
    /// 데이터를 정리하고 idle 상태로 변경
    func cleanup() {
        status = .idle
        error = nil
        data = nil
    }
    
    /// 내부 애니메이션 처리
    /// withAnimation 이 nil 이 아닐 때만 에니매이션 처리
    private func internalWithAnimation(_ animation: Animation?, action: @MainActor @escaping () -> Void) {
        mainAsync {
            if animation != nil {
                withAnimation(animation) {
                    action()
                }
            } else {
                action()
            }
        }
    }
}
