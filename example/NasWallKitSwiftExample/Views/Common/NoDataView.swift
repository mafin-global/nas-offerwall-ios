import SwiftUI

/**
 조회 정보가 없는 경우에 아이콘과 함께 지정 텍스트를 보여주는 View

 ```swift
 NoDataView("정보가 없습니다.")
 ```
 */
struct NoDataView: View {
    // MARK: - Variable

    /// 텍스트
    private var text: String

    // MARK: - init

    init(_ text: String) {
        self.text = text
    }

    // MARK: - body

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "text.page.badge.magnifyingglass")
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)

            Text(text)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.secondary)
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("NoDataView") {
        NoDataView("정보가 없습니다.")
    }
}
