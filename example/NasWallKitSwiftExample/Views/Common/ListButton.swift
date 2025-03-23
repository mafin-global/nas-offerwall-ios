import SwiftUI

/// `List` 내에 아이콘, 제목 형태의 버튼을 표시하는 `View`
///
/// ```swift
/// ListButton("버튼", icon: "questionmark", color: .blue) {
///     // 클릭 시 실행 코드
/// }
/// ```
struct ListButton: View {
    // MARK: - Variable

    /// 제목
    private var title: String
    /// 아이콘 (System Image)
    private var icon: String
    /// 버튼 색상
    private var color: Color
    /// 클릭 핸들러
    private var action: () -> Void

    // MARK: - init

    /// 초기화
    ///
    /// - Parameters:
    ///   - title: 제목
    ///   - icon: 아이콘 (System Image)
    ///   - color: 아이콘 색상
    ///   - action: 클릭 핸들러
    init(_ title: String, icon: String, color: Color, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }

    // MARK: - body

    var body: some View {
        Button(action: action, label: {
            ListLabel(title, icon: icon, color: color)
        })
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("ListButton") {
        List {
            ListButton("버튼", icon: "questionmark", color: .blue) {
                ll("버튼 클릭")
            }
        }
    }
}
