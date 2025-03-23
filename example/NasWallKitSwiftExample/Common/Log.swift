///
/// 로그 기록 함수 및 클래스
///
/// 디버그 모드에서만 로그를 출력하기 위해 print 대신 사용
///
/// `ll()` = 디버그 로그 출력
/// `lli()` = 정보 로그 출력
/// `lls()` = 성공 로그 출력
/// `llw()` = 경고 로그 출력
/// `lle()` = 오류 로그 출력
/// `llf()` = 심각한 오류 로그 출력
///

import Foundation
import OSLog

private enum LogType {
    case log
    case debug
    case info
    case success
    case warning
    case error
    case fault
}

private let logger = Logger()

#if DEBUG
    private let projectName = "[\(Bundle(for: Log.self).object(forInfoDictionaryKey: "CFBundleName") as? String ?? "")] "

    // MARK: - 내부 함수

    /// 함수명을 단순화 하기 위한 함수
    ///
    ///     "func(param1:param2:)" -> "func"
    ///
    private func getFunctionName(_ name: String) -> String {
        name.split(separator: "(").first.map { String($0) } ?? name
    }

    /// 파일명을 단순화 하기 위한 함수
    ///
    /// 기본
    ///
    ///     ".../dir/file.swift" -> "file.swift"
    ///
    /// `ext=false` 인 경우
    ///
    ///     ".../dir/file.swift" -> "file"
    ///
    private func getFileName(_ name: String, ext: Bool = true) -> String {
        if ext {
            name.split(separator: "/").last.map { String($0) } ?? name
        } else {
            name.split(separator: "/").last.map { String($0) }?.split(separator: ".").first.map { String($0) } ?? name
        }
    }

    /// Type명을 단순화 하기 위한 함수
    ///
    ///     "Optional(TestProject.TypeName)" -> "TypeName"
    ///
    private func getTypeName(_ type: Any.Type) -> String {
        String(describing: type)
            .split(separator: "(").last.map { String($0) }?
            .split(separator: ")").first.map { String($0) }?
            .split(separator: ".").last.map { String($0) }
            ?? ""
    }

    /// 머리말 만드는 함수
    ///
    ///     [프로젝트명] [클래스명.함수명:라인번호]
    ///     [프로젝트명] [파일명] [함수명:라인번호]
    ///
    private func getLogHeading(file: String, type: Any.Type?, functionName: String, line: UInt, logType _: LogType) -> String {
        //    var heading = isError ? "!!! " : ""
        var heading = projectName

        let functionName = getFunctionName(functionName)

        if type != nil {
            let typeName = getTypeName(type!)
            heading.append("[\(typeName).\(functionName)()")
        } else {
            heading.append("[\(getFileName(file, ext: true))] [\(functionName)()")
        }

        heading.append(":\(line)]")

        return heading
    }

    /// 최종 로그 출력
    private func printLog(_ items: [Any], file: String, type: Any.Type?, functionName: String, line: UInt, logType: LogType = .debug) {
        let heading = getLogHeading(file: file, type: type, functionName: functionName, line: line, logType: logType)

        var icon: String
        var level: OSLogType
        switch logType {
        case .log: icon = ""; level = .default
        case .debug: icon = "🐛 "; level = .debug
        case .info: icon = "ℹ️ "; level = .info
        case .success: icon = "✅ "; level = .info
        case .warning: icon = "⚠️ "; level = .error
        case .error: icon = "🔥 "; level = .error
        case .fault: icon = "⚡ "; level = .fault
        }

        let message = "\(icon)\(heading) \(items.map { "\($0)" }.joined(separator: " | "))"

        if isPreview {
            print(message)
        } else {
            logger.log(level: level, "\(message)")
        }
    }
#endif

// MARK: - 디버그 로그 출력

/// 디버그 로그 출력
///
/// ```swift
/// ll("message1", "message2", ...)
/// ```
func ll(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: nil, functionName: functionName, line: line, logType: .debug)
    #endif
}

/// 디버그 로그 출력 (`type` 지정)
///
/// ```swift
/// ll("message1", "message2", ..., type: Self.self)
/// ```
func ll(_ items: Any..., type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: type, functionName: functionName, line: line, logType: .debug)
    #endif
}

// MARK: - 정보 로그 출력

/// 정보 로그 출력
///
/// ```swift
/// lli("message1", "message2", ...)
/// ```
func lli(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: nil, functionName: functionName, line: line, logType: .info)
    #endif
}

/// 정보 로그 출력 (`type` 지정)
///
/// ```swift
/// lli("message1", "message2", ..., type: Self.self)
/// ```
func lli(_ items: Any..., type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: type, functionName: functionName, line: line, logType: .info)
    #endif
}

// MARK: - 성공 로그 출력

/// 성공 로그 출력
///
/// ```swift
/// lls("message1", "message2", ...)
/// ```
func lls(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: nil, functionName: functionName, line: line, logType: .success)
    #endif
}

/// 성공 로그 출력 (`type` 지정)
///
/// ```swift
/// lls("message1", "message2", ..., type: Self.self)
/// ```
func lls(_ items: Any..., type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: type, functionName: functionName, line: line, logType: .success)
    #endif
}

// MARK: - 경고 로그 출력

/// 경고 로그 출력
///
/// ```swift
/// llw("message1", "message2", ...)
/// ```
func llw(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: nil, functionName: functionName, line: line, logType: .warning)
    #endif
}

/// 경고 로그 출력 (`type` 지정)
///
/// ```swift
/// llw("message1", "message2", ..., type: Self.self)
/// ```
func llw(_ items: Any..., type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: type, functionName: functionName, line: line, logType: .warning)
    #endif
}

// MARK: - 심각한 오류 로그 출력

/// 심각한 오류 로그 출력
///
/// ```swift
/// llf("message1", "message2", ...)
/// ```
func llf(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: nil, functionName: functionName, line: line, logType: .fault)
    #endif
}

/// 심각한 오류 로그 출력 (`type` 지정)
///
/// ```swift
/// llf("message1", "message2", ..., type: Self.self)
/// ```
func llf(_ items: Any..., type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog(items, file: file, type: type, functionName: functionName, line: line, logType: .fault)
    #endif
}

// MARK: - NSError 오류 로그 출력

/// `NSError` 오류 로그 출력
///
/// ```swift
/// lle(error)
/// ```
func lle(_ error: NSError, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([error.code, error.localizedDescription], file: file, type: nil, functionName: functionName, line: line, logType: .error)
    #endif
}

/// `NSError` 오류 로그 출력 (`type` 지정)
///
/// ```swift
/// lle(error, type: Self.self)
/// ```
func lle(_ error: NSError, type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([error.code, error.localizedDescription], file: file, type: type, functionName: functionName, line: line, logType: .error)
    #endif
}

// MARK: - NSError 오류 로그 출력 (메시지 지정)

/// `NSError` 오류 로그 출력 (메시지 지정)
///
/// ```swift
/// lle("message", error)
/// ```
func lle(_ msg: String, error: NSError, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([msg, error.code, error.localizedDescription], file: file, type: nil, functionName: functionName, line: line, logType: .error)
    #endif
}

/// `NSError` 오류 로그 출력 (메시지, `type` 지정)
///
/// ```swift
/// lle("message", error, type: Self.self)
/// ```
func lle(_ msg: String, error: NSError, type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([msg, error.code, error.localizedDescription], file: file, type: type, functionName: functionName, line: line, logType: .error)
    #endif
}

// MARK: - Error 오류 로그 출력

/// `Error` 오류 로그 출력
///
/// ```swift
/// lle(error)
/// ```
func lle(_ error: Error, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([error.localizedDescription], file: file, type: nil, functionName: functionName, line: line, logType: .error)
    #endif
}

/// `Error` 오류 로그 출력 (`type` 지정)
///
/// ```swift
/// lle(error, type: Self.self)
/// ```
func lle(_ error: Error, type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([error.localizedDescription], file: file, type: type, functionName: functionName, line: line, logType: .error)
    #endif
}

// MARK: - Error 오류 로그 출력 (메시지 지정)

/// `Error` 오류 로그 출력 (메시지 지정)
///
/// ```swift
/// lle("message", error)
/// ```
func lle(_ msg: String, error: Error, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([msg, error.localizedDescription], file: file, type: nil, functionName: functionName, line: line, logType: .error)
    #endif
}

/// `Error` 오류 로그 출력 (메시지, `type` 지정)
///
/// ```swift
/// lle("message", error, type: Self.self)
/// ```
func lle(_ msg: String, error: Error, type: Any.Type, functionName: String = #function, line: UInt = #line, file: String = #file) {
    #if DEBUG
        printLog([msg, error.localizedDescription], file: file, type: type, functionName: functionName, line: line, logType: .error)
    #endif
}

// MARK: - Log 클래스

/// 로그 출력 시 자동으로 클래스명을 함께 출력하기 위한 Log 클래스
///
/// ```swift
/// class MyClass : Log {
///     func test() {
///         ll("Hello World!", "This is test.")
///     }
/// }
/// ```
class Log {
    /// 디버그 로그 출력
    ///
    /// ```swift
    /// ll("message1", "message2", ...)
    /// ```
    func ll(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog(items, file: file, type: Self.self, functionName: functionName, line: line, logType: .debug)
        #endif
    }

    /// 정보 로그 출력
    ///
    /// ```swift
    /// lli("message1", "message2", ...)
    /// ```
    func lli(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog(items, file: file, type: Self.self, functionName: functionName, line: line, logType: .info)
        #endif
    }

    /// 성공 로그 출력
    ///
    /// ```swift
    /// lls("message1", "message2", ...)
    /// ```
    func lls(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog(items, file: file, type: Self.self, functionName: functionName, line: line, logType: .success)
        #endif
    }

    /// 경고 로그 출력
    ///
    /// ```swift
    /// llw("message1", "message2", ...)
    /// ```
    func llw(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog(items, file: file, type: Self.self, functionName: functionName, line: line, logType: .warning)
        #endif
    }

    /// 심각한 오류 로그 출력
    ///
    /// ```swift
    /// llf("message1", "message2", ...)
    /// ```
    func llf(_ items: Any..., functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog(items, file: file, type: Self.self, functionName: functionName, line: line, logType: .fault)
        #endif
    }

    /// `NSError` 오류 로그 출력
    ///
    /// ```swift
    /// lle(error)
    /// ```
    func lle(_ error: NSError, functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog([error.code, error.localizedDescription], file: file, type: Self.self, functionName: functionName, line: line, logType: .error)
        #endif
    }

    /// `NSError` 오류 로그 출력 (메시지 지정)
    ///
    /// ```swift
    /// lle("message", error)
    /// ```
    func lle(_ msg: String, error: NSError, functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog([msg, error.code, error.localizedDescription], file: file, type: Self.self, functionName: functionName, line: line, logType: .error)
        #endif
    }

    /// `Error` 오류 로그 출력
    ///
    /// ```swift
    /// lle(error)
    /// ```
    func lle(_ error: Error, functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog([error.localizedDescription], file: file, type: Self.self, functionName: functionName, line: line, logType: .error)
        #endif
    }

    /// `Error` 오류 로그 출력 (메시지 지정)
    ///
    /// ```swift
    /// lle("message", error)
    /// ```
    func lle(_ msg: String, error: Error, functionName: String = #function, line: UInt = #line, file: String = #file) {
        #if DEBUG
            printLog([msg, error.localizedDescription], file: file, type: Self.self, functionName: functionName, line: line, logType: .error)
        #endif
    }
}
