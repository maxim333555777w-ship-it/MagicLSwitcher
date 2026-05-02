//
//  SwitchDecision.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 23.4.2026.
//

import Foundation

struct LayoutSwitchDecision {
    enum Action {
        case none
        case wait
        case switchLayout
    }
    let action: Action
    let targetLayoutID: String?
    let confidence: Double
    let reason: String
    
    init(
        action: Action,
        targetLayoutID: String? = nil,
        confidence: Double = 0.0,
        reason: String = ""
    ) {
        self.action = action
        self.targetLayoutID = targetLayoutID
        self.confidence = confidence
        self.reason = reason
    }
}
