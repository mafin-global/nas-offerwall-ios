import SwiftUI

/**
 Preview 상태에서 네비게이션바를 표시하고, 테마 변경을 지원하기 위한 View

 ```swift
 PreviewNavigationView("네이게이션 타이틀") {
    // 컨텐츠
 }
 ```
 */
struct PreviewNavigationView<Content: View>: View {
    // MARK: - Environment

    /// Environment 테마
    @Environment(\.colorScheme) private var envColorScheme

    // MARK: - Variable

    /// 테마
    @State private var colorScheme: ColorScheme?
    /// 제목
    @State private var title: String
    /// 컨텐츠
    @State private var content: Content

    // MARK: - init

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    // MARK: - body

    var body: some View {
        NavigationView {
            VStack {
                content
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            // 네비게이션바 좌측의 테마 변경 버튼
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("테마", systemImage: "circle.lefthalf.filled") {
                        if colorScheme == nil {
                            colorScheme = envColorScheme == .dark ? .light : .dark
                        } else {
                            colorScheme = colorScheme == .dark ? .light : .dark
                        }
                    }
                }
            }
        }
        .colorScheme(colorScheme ?? envColorScheme)
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("PreviewNavigationView") {
        Text("Content")
    }
}
