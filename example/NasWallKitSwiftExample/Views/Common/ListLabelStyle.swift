import SwiftUI

/// `Label`의 아이콘을 사각의 색상 형태로 변경해주는 `LabelStyle`
///
/// ```swift
/// Label("설정", systemImage: "gearshape")
///     .labelStyle(ListLabelStyle(color: .green))
/// ```
struct ListLabelStyle: LabelStyle {
    // MARK: - Variable

    /// 버튼 색상
    private var color: Color
    /// 버튼 크기 비율
    private var scale: CGFloat = 1

    // MARK: - init

    /// 초기화
    ///
    /// - Parameters:
    ///   - color: 아이콘 색상
    ///   - scale: 버튼 크기 비율
    init(color: Color, scale: CGFloat = 1) {
        self.color = color
        self.scale = scale
    }

    // MARK: - makeBody

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .imageScale(.small)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 7 * scale).frame(width: 28 * scale, height: 28 * scale).foregroundColor(color))
        }
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("ListLabelStyle") {
        List {
            Label("설정", systemImage: "gearshape")
                .labelStyle(ListLabelStyle(color: .green))
        }
    }
}
