//
//  LayoutProjection.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 23.4.2026.
//

import Foundation
import AppKit

struct LayoutProjection {
    let layoutID: String
    let text: String
    let frames: [KeyInputFrame]
    var length: Int {
        frames.count
    }
    var isEmpty: Bool {
        frames.isEmpty || text.isEmpty
    }
    init(
        layoutID: String,
        text: String,
        frames: [KeyInputFrame]
    ) {
        self.layoutID = layoutID
        self.text = text
        self.frames = frames
    }
    static func build(layoutID: String, frames: [KeyInputFrame]) -> LayoutProjection {
        var result = ""
        
        for frame in frames {
            guard frame.eventType == .keyDown else { continue }
            let translatedCharacter = KeyboardLayoutBridge.translateKeyCode(
                frame.keyCode,
                modifiers: UInt32(frame.modifiers.rawValue),
                layoutID: layoutID
            )
            if let translatedCharacter {
                result.append(translatedCharacter)
            }
        }
        return LayoutProjection(
            layoutID: layoutID,
            text: result,
            frames: frames
        )
    }
}
