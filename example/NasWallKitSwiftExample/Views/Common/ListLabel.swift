import SwiftUI

/// `List` 내에 아이콘, 제목 형태의 레이블을 표시하는 `View`
///
/// `ListButton`, `LstLink`, `ListValue` 내에서 사용됨
///
/// ```swift
/// ListLabel("제목", icon: "questionmark", color: .purple)
/// ```
struct ListLabel: View {
    // MARK: - Variable

    /// 제목
    private var title: String
    /// 아이콘 (System Image)
    private var icon: String
    /// 버튼 색상
    private var color: Color

    // MARK: - init

    /// 초기화
    ///
    /// - Parameters:
    ///   - title: 제목
    ///   - icon: 아이콘 (System Image)
    ///   - color: 아이콘 색상
    init(_ title: String, icon: String, color: Color) {
        self.title = title
        self.icon = icon
        self.color = color
    }

    // MARK: - body

    var body: some View {
        Label(title, systemImage: icon).labelStyle(ListLabelStyle(color: color))
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("ListLabel") {
        List {
            ListLabel("제목", icon: "questionmark", color: .purple)
        }
    }
}
