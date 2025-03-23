import SwiftUI

/**
 투명 배경 - UIViewRepresentable

 모달 창에 투명 배경을 적용할 때 사용합니다.

 ```swift
 VStack {
     ...
 }
 .background(ClearBackground())
 ```
 */
struct ClearBackground: UIViewRepresentable {
    // MARK: - Variable

    /// 투명도
    private var opacity: Double

    // MARK: - init

    init(opacity: Double = 0.3) {
        self.opacity = opacity
    }

    // MARK: - Function

    func makeUIView(context _: Context) -> UIView {
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: opacity)
        }
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}

// MARK: -

/// 투명 배경 View
private class ClearBackgroundView: UIView {
    override open func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}
