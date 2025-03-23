import SwiftUI

/// 오류 및 재시도 버튼을 표시하는 VIew
///
/// `action` 지정 시 재시도 버튼이 노출됩니다.
///
/// - Important: `Release` 모드에서는 `error`(NSError) 지정 시 `localizedDescription` 이 기본적으로 표시되지 않습니다. 오류 코드를 누르면 `localizedDescription`이 표시됩니다.
///
/// ```swift
/// // 기본 메시지
/// ErrorRetry()
///
/// // 메시지 지정
/// ErrorRetry("정보를 불러올 수 없습니다.")
///
/// // 기본 메시지, 오류 코드 지정
/// ErrorRetry(code: 999)
///
/// // 메시지, 오류 코드 지정
/// ErrorRetry("정보를 불러올 수 없습니다.", code: 999)
///
/// // NSError 지정
/// ErrorRetry(error)
///
/// // 메시지, NSError 지정
/// ErrorRetry("정보를 불러올 수 없습니다.", error: error)
///
/// // 재시도 사용 (모든 유형)
/// ErrorRetry(...) {
///     // 재시도 실행 코드
/// }
/// ```

struct ErrorRetry: View {
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Variable

    /// 오류 코드
    private var code: Int?
    /// 오류 메시지
    private var msg: String = "예상치 못한 문제가 발생했습니다."
    /// 숨김 메시지
    private var secretMsg: String?
    /// 재시도 클릭 액션 핸들러
    private var action: (() -> Void)?
    /// 초기화 숨김 메시지 표시 여부
    private var initShowSecretMsg: Bool = false
    /// 숨김 메시지 표시 여부
    @State private var isShowSecretMsg: Bool = false // isDebugMode()

    // MARK: - init

    /// - Parameter action: 재시도 클릭 액션 핸들러
    init(_ action: (() -> Void)? = nil) {
        self.action = action
    }

    /// - Parameter msg: 오류 메시지
    /// - Parameter code: 오류 코드
    /// - Parameter action: 재시도 클릭 액션 핸들러
    init(_ msg: String? = nil, code: Int? = nil, action: (() -> Void)? = nil) {
        if msg != nil {
            self.msg = msg!
        }
        self.code = code
        self.action = action
    }

    /// - Parameter msg: 오류 메시지
    /// - Parameter error: `NSError` 객체
    /// - Parameter showSecretMsg: 숨김 메시지를 표시할지 여부
    /// - Parameter action: 재시도 클릭 액션 핸들러
    init(_ msg: String, error: NSError? = nil, showSecretMsg: Bool = false, action: (() -> Void)? = nil) {
        self.msg = msg
        if error != nil {
            code = error!.code
            secretMsg = error!.localizedDescription
        }
        initShowSecretMsg = showSecretMsg
        self.action = action
    }

    /// - Parameter error: `NSError` 객체
    /// - Parameter showSecretMsg: 숨김 메시지를 표시할지 여부
    /// - Parameter action: 재시도 클릭 액션 핸들러
    init(_ error: NSError?, showSecretMsg: Bool = false, action: (() -> Void)? = nil) {
        if error != nil {
            secretMsg = error!.localizedDescription
            code = error!.code
        }
        initShowSecretMsg = showSecretMsg
        self.action = action
    }

    // MARK: - body

    var body: some View {
        VStack(spacing: 25) {
            VStack(spacing: 15) {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.primary.opacity(0.7))
                        .frame(width: 32, height: 32)

                    if code != nil || (secretMsg != nil && isShowSecretMsg) {
                        VStack(spacing: 3) {
                            if code != nil {
                                Text("\(code!)")
                            }

                            if secretMsg != nil && isShowSecretMsg {
                                Text(secretMsg!)
                                    .cornerRadius(5)
                            }
                        }
                        .font(.footnote)
                        .padding(.horizontal, secretMsg != nil && isShowSecretMsg ? 10 : 4)
                        .padding(.vertical, secretMsg != nil && isShowSecretMsg ? 5 : 2)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .background(.primary.opacity(0.5))
                        .cornerRadius(5)
                        .onTapGesture {
                            if secretMsg != nil && !isShowSecretMsg {
                                isShowSecretMsg = true
                            }
                        }
                    }
                }

                Text(action != nil ? "\(msg)\n잠시 후 재시도 해주세요." : msg)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary.opacity(0.7))
            }

            if action != nil {
                MyButton("재시도") {
                    action!()
                }
                .frame(maxWidth: 150)
            }
        }
        .padding()
        .onAppear {
            // 초기화 숨김 메시지 표시 여부가 true 이면 isShowSecretMsg 값 변경
            if initShowSecretMsg && !isShowSecretMsg {
                isShowSecretMsg = initShowSecretMsg
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
    #Preview {
        PreviewNavigationView("ErrorRetry") {
            ScrollView {
                VStack(spacing: 20) {
                    PreviewGroup {
                        ErrorRetry()
                    }

                    PreviewGroup {
                        ErrorRetry("정보를 불러올 수 없습니다.")
                    }

                    PreviewGroup {
                        ErrorRetry("정보를 불러올 수 없습니다.", code: -1000)
                    }

                    PreviewGroup {
                        ErrorRetry(NSError(domain: "", code: -1000, userInfo: [NSLocalizedDescriptionKey: "알 수 없는 오류가 발생했습니다."])) {
                            ll("재시도")
                        }
                    }

                    PreviewGroup {
                        ErrorRetry("목록을 불러올 수 없습니다.", error: NSError(domain: "", code: -1000, userInfo: [NSLocalizedDescriptionKey: "서버에 연결할 수 없습니다."]), showSecretMsg: true) {
                            ll("재시도")
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
        .colorScheme(.dark)
    }

    private struct PreviewGroup<Content: View>: View {
        @Environment(\.colorScheme) private var colorScheme
        private var content: Content

        init(@ViewBuilder _ content: () -> Content) {
            self.content = content()
        }

        var body: some View {
            VStack {
                content
            }
            .frame(maxWidth: .infinity)
            .background(Color(colorScheme == .dark ? UIColor.secondarySystemBackground : UIColor.systemBackground))
            .cornerRadius(10)
        }
    }
#endif
