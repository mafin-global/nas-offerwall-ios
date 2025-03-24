import SwiftUI

/**
 기본 넓이가 100% 이고,  스타일이 `borderedProminent` 형태의 버튼

 ```swift
 // 기본 버튼
 Button("버튼") {
    // 클릭 시 실행 코드
 }

 // 버튼 색상 지정
 Button("버튼", color: .purple) {
    // 클릭 시 실행 코드
 }

 // 버튼, 레이블 색상 지정
 Button("버튼", color: .gray, labelColor: .red) {
    // 클릭 시 실행 코드
 }

 // 로딩 상태 지정
 Button("버튼", loading: loading) {
    // 클릭 시 실행 코드
 }
 ```
 */
struct MyButton: View {
    // MARK: - Variable
    
    /// 레이블
    private var label: String
    /// 클릭 액션 핸들러
    private var action: (() -> Void)?
    /// 버튼 색상
    private var color: Color
    /// 레이블 색상
    private var labelColor: Color
    /// 로딩 여부
    private var loading: Bool
    
    // MARK: - init
    
    init(_ label: String, color: Color = .blue, labelColor: Color = .white, loading: Bool = false, action: (() -> Void)? = nil) {
        self.label = label
        self.color = color
        self.labelColor = labelColor
        self.action = action
        self.loading = loading
    }
    
    // MARK: - body
    
    var body: some View {
        Button {
            if loading == false {
                action?()
            }
        } label: {
            HStack {
                if loading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)
                }
                
                Text(label)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(MyButtonStyle(color: color, labelColor: labelColor))
        .disabled(loading)
    }
}

// MARK: - MyButtonStyle

/// 기본 버튼 스타일
private struct MyButtonStyle: ButtonStyle {
    private(set) var color: Color
    private(set) var labelColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(labelColor)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .disabled(configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("MyButton") {
        VStack {
            MyButton("Button") {
                ll("Button pressed")
            }
            
            MyButton("Button", loading: true) {
                ll("Button pressed")
            }
        }
        .padding()
    }
}
