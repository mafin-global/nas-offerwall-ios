import SwiftUI

/// 초기화 상태
private enum InitializeStatus {
    case idle
    case initializing
    case initialized
    case failed
}

/**
 Preview 상태에서 NasWallKit 을 초기화 해주기 위한 View

 ```swift
 PreviewNasWallInitView {
    // 컨텐츠
 }
 ```
 */
struct PreviewNasWallInitView<Content: View>: View {
    // MARK: - Variable

    /// NasWallKit - 초기화
    @StateObject private var nwkInitialize = NasWallKit_Initialize()
    /// 컨텐츠
    @State private var content: Content

    // MARK: - init

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    // MARK: - Function

    /// 초기화 실행
    private func initialize() {
        nwkInitialize.loadData()
    }

    // MARK: - body

    var body: some View {
        ZStack {
            switch nwkInitialize.status {
            case .idle, .loading: // 초기화 중
                ProgressView()

            case .fail: // 초기화 실패
                ErrorRetry("NasWall SDK 초기화에 실패하였습니다.", error: nwkInitialize.error, action: initialize)

            case .success: // 초기화 성공
                content
            }
        }
        .onAppear {
            initialize()
        }
    }
}

// MARK: - Preview

#Preview {
    PreviewNasWallInitView {
        Text("초기화 완료")
    }
}
