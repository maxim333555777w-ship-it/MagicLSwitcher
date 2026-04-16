import Foundation
import ApplicationServices

final class AccessibilityPermission {
    static func isEnabled() -> Bool {
        AXIsProcessTrusted()
    }
    static func request() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}

