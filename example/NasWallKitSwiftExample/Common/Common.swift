import NasWallKit
import SwiftUI

/// 미리보기(Preview) 모드 인지 여부
let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

/// 디버그 모드 인지 여부
func isDebugMode() -> Bool {
    var isDebug = false
    assert({
        isDebug = true
        return true
    }())
    return isDebug
}

/// 메인 스레드에서 액션 실행
func mainAsync(_ action: @MainActor @escaping () -> Void) {
    DispatchQueue.main.async(execute: action)
}

/// 메인 스레드에서 지정 시간(초) 후 액션 실행
func mainAsyncAfter(seconds: Double, action: @MainActor @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: action)
}
