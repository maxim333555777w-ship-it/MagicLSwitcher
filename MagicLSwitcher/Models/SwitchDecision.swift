//
//  SwitchDecision.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 18.4.2026.
//

import Foundation

enum SwitchDirection {
    case russian
    case english
}

struct SwitchDecision {
    let shouldSwitch: Bool
    let direction: SwitchDirection?
    let originalText: String
    let convertedText: String?
}
