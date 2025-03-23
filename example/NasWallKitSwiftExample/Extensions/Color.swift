import SwiftUI

extension Color {
    /**
     Hex 값으로 초기화

     ```swift
     Color.init(0x112233)
     Color.init(0x112233, alpha: 0.5)
     ```
     */
    init(_ hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 08) & 0xFF) / 255,
            blue: Double((hex >> 00) & 0xFF) / 255,
            opacity: alpha
        )
    }

    /**
     Hex 텍스트 값으로 초기화

     ```swift
     Color.init("#112233")
     Color.init("#112233", alpha: 0.5)

     Color.init("112233")
     Color.init("112233", alpha: 0.5)
     ```
     */
    init(hex: String, alpha: Double = 1) {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        self.init(
            .sRGB,
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
}
