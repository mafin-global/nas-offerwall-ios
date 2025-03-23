import SwiftUI

/// 검은색 사각형에 ProgressView 를 표시하는 View
///
/// ```swift
/// LoadingView()
/// ```
struct LoadingView: View {
    var body: some View {
        ZStack {
            ProgressView()
                .controlSize(.regular)
                .scaleEffect(1.3)
                .padding(40)
                .tint(.white)
        }
        .background(.black.opacity(0.7))
        .cornerRadius(25)
    }
}

#Preview {
    PreviewNavigationView("LoadingView") {
        LoadingView()
    }
}
