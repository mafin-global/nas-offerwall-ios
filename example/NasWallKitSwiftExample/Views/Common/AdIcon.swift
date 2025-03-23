import SwiftUI

/**
 광고 아이콘 이미지 View

 ```swift
 // 기본 사이즈 (50)
 AdIcon("이미지 URL")

 // 사이즈 지정
 AdIcon("이미지 URL", size: 30)
 ```
 */
struct AdIcon: View {
    // MARK: - Private Variable

    /// 아이콘 URL
    private var url: String
    /// 크기
    private var size: CGFloat

    // MARK: - init

    init(_ url: String, size: CGFloat = 50) {
        self.url = url
        self.size = size
    }

    // MARK: - body

    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image.image?
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(size / 4)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("Icon") {
        VStack(spacing: 30) {
            AdIcon("https://nextapps-nas.aws.appang.kr/icon/20230809132818555165063_1691555309.png")

            AdIcon("https://nextapps-nas.aws.appang.kr/icon/20230809132818555165063_1691555309.png", size: 114)
        }
    }
}
