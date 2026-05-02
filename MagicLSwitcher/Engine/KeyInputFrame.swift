//
//  KeyInputFrame.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 23.4.2026.
//

import Foundation
import AppKit

struct KeyInputFrame {
    let id: UUID
    let keyCode: UInt16
    let timestamp: TimeInterval
    let modifiers: NSEvent.ModifierFlags
    let eventType: EventType
    
    enum EventType {
        case keyDown
        case keyUp
    }
    
    init(
        keyCode: UInt16,
        timeStamp: TimeInterval = Date().timeIntervalSince1970,
        modifiers: NSEvent.ModifierFlags = [],
        eventType: EventType = .keyDown
    ) {
        self.id = UUID()
        self.keyCode = keyCode
        self.timestamp = timeStamp
        self.modifiers = modifiers
        self.eventType = eventType
    }
}
