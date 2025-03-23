import SwiftUI

/**
 모달 View

 배경이 투명한 전체 화면 모달의 기본 구조 View

 ```swift
 ModalView("제목") {
    // 컨텐츠 코드
 }
 .titleForegroundColor(Color) // 제목 색상 지정
 .titleBackgroundColor(Color) // 제목 배경 색상 지정
 .closeDisable(Bool) // 닫기 버튼 활성화/비활성화
 .onClose {
    // 모달 종료 시 실행 코드
 }
 ```
 */
struct ModalView<Content: View>: View {
    // MARK: - Environment

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Private Variable

    /// 컨텐츠 View
    private let content: Content
    /// 제목
    private var title: String
    /// 타이틀 배경 스타일
    private var titleBackgroundColor: Color = .blue
    /// 타이틀 전경 스타일
    private var titleForegroundColor: Color = .white
    /// 닫기 버튼 클릭 시 실행 액션
    private var onCloseAction: (() -> Void)?
    /// 닫기 버튼 비활성화 여부
    private var closeDisabled: Bool = false

    // MARK: - init

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }

    // MARK: - Function

    /// 닫기 버튼 클릭 시 액션 지정
    func onClose(_ action: @escaping () -> Void) -> Self {
        var new = self
        new.onCloseAction = action
        return new
    }

    /// 닫기 버튼 비활성화 여부 지정
    func closeDisabled(_ disabled: Bool) -> Self {
        var new = self
        new.closeDisabled = disabled
        return new
    }

    /// 타이틀 배경 색상 지정
    func titleBackgroundColor(_ color: Color) -> Self {
        var new = self
        new.titleBackgroundColor = color
        return new
    }

    /// 타이틀 전경 색상 지정
    func titleForegroundColor(_ color: Color) -> Self {
        var new = self
        new.titleForegroundColor = color
        return new
    }

    // MARK: - body

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                // 타이틀바
                ZStack {
                    // 제목
                    Text(title)
                        .foregroundStyle(titleForegroundColor)
                        .font(.headline.bold())

                    HStack {
                        Spacer()

                        // 닫기 버튼
                        Button {
                            self.onCloseAction?()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(titleForegroundColor)
                                .opacity(closeDisabled ? 0.5 : 1)
                        }
                        .disabled(closeDisabled)
                        .padding(10)
                    }
                }
                .background(titleBackgroundColor)

                VStack(spacing: 0) {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.8), radius: 20)
        }
        .padding()
        .background(ClearBackground())
    }
}

// MARK: - Preview

#Preview {
    ModalView("Title") {
        Text("Content")
    }
    .onClose {
        ll("닫기 버튼 클릭")
    }
}
