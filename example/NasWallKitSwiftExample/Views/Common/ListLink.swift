import SwiftUI

/// List 내에 아이콘, 제목 형태의 `NavigationLink`를 표시하는 View
///
/// ```swift
/// ListButton("버튼", icon: "questionmark", color: .blue) {
///    // 클릭 시 실행 코드
/// }
/// ```
struct ListLink<Content: View>: View {
    // MARK: - Variable

    /// 제목
    private var title: String
    /// 아이콘 (System Image)
    private var icon: String
    /// 버튼 색상
    private var color: Color
    /// 클릭 시 이동할 대상 View
    private var destination: Content

    // MARK: - init

    /// 초기화
    ///
    /// - Parameters:
    ///   - title: 제목
    ///   - icon: 아이콘 (System Image)
    ///   - color: 아이콘 색상
    ///   - destination: 클릭 시 이동할 대상 View
    ///
    init(_ title: String, icon: String, color: Color, destination: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.destination = destination()
    }

    // MARK: - body

    var body: some View {
        NavigationLink(destination: destination) {
            ListLabel(title, icon: icon, color: color)
        }
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("ListLink") {
        List {
            ListLink("버튼", icon: "questionmark", color: .blue) {
                Text("Content")
                    .navigationTitle("Destination")
            }
        }
    }
}
