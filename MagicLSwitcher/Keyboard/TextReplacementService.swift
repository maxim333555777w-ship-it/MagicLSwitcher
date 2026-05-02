//
//  TextReplacementService.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 16.4.2026.
//
import Foundation
import ApplicationServices
import Carbon

final class TextReplacementService {
    func deleteLastCharacter(count: Int) {
        for _ in 0..<count {
            let backspaceDown = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(kVK_Delete), keyDown: true)
            backspaceDown?.post(tap: .cghidEventTap)
            let backspaceUp = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(kVK_Delete), keyDown: false)
            backspaceUp?.post(tap: .cghidEventTap)
        }
    }
    func insertText(_ text: String) {
        for char in text {
            let string = String(char)
            let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true)
            event?.keyboardSetUnicodeString(stringLength: string.utf16.count, unicodeString: Array(string.utf16))
            event?.post(tap: .cghidEventTap)
            
        }
    }
}
