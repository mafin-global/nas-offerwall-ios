import SwiftUI

/// `List` 내에 아이콘, 제목, 값 형태를 표시하는 `View`
///
/// ```swift
/// ListValue("내 적립금", icon: "wonsign", color: .brown) {
///     Text("358,000원")
/// }
/// ```
struct ListValue<Content: View>: View {
    // MARK: - Variable

    /// 제목
    private var title: String
    /// 아이콘 (System Image)
    private var icon: String
    /// 버튼 색상
    private var color: Color
    /// 우측 영역 컨텐츠
    private var content: Content

    // MARK: - init

    /// 초기화
    ///
    /// - Parameters:
    ///   - title: 제목
    ///   - icon: 아이콘 (System Image)
    ///   - color: 아이콘 색상
    ///   - content: 우측 영역 컨텐츠
    init(_ title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }

    // MARK: - body

    var body: some View {
        HStack {
            ListLabel(title, icon: icon, color: color)

            Spacer()

            content
        }
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("ListValue") {
        List {
            ListValue("내 적립금", icon: "wonsign", color: .brown) {
                Text("358,000원")
            }
        }
    }
}
