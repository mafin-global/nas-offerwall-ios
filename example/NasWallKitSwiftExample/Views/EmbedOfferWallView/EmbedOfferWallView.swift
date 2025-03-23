//
// 임베드 오퍼월 메인 화면
//

import NasWallKit
import SwiftUI

// MARK: -

/// `NasWall.embedOfferWallView()` 에 필요한 `UIView`를 만들기 위한 `UIViewRepresentable`
private struct EmbedOfferWall: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        let view = UIView()

        NasWall.embedOfferWall(view) { error in
            if error != nil {
                lle("NasWall.embedOfferWall() 실패", error: error!)
            } else {
                lls("NasWall.embedOfferWall() 성공")
            }
        }

        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}

// MARK: -

/// 임베드 오퍼월 메인 `View`
struct EmbedOfferWallView: View {
    // MARK: - Function

    /// 문의하기 열기
    private func openCs() {
        NasWall.openCs { error in
            if error != nil {
                lle("NasWall.openCs() 실패", error: error!)
            } else {
                lls("NasWall.openCs() 성공")
            }
        } closeHandler: {
            lli("문의하기 종료")
        }
    }

    // MARK: - body

    var body: some View {
        VStack {
            EmbedOfferWall()
        }
        .navigationTitle("임베드 오퍼월")
        .navigationBarTitleDisplayMode(.inline)
        // 네비게이션바 우측 문의하기 버튼
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("문의하기", systemImage: "questionmark.circle.fill", action: openCs)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PreviewNavigationView("EmbedOfferWallView") {
        PreviewNasWallInitView {
            EmbedOfferWallView()
        }
    }
}
