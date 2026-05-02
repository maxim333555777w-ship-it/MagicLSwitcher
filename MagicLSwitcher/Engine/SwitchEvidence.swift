//
//  SwitchEvidence.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 30.4.2026.
//

import Foundation

struct SwitchEvidence {
    let currentLayoutID: String
    let alternativeLayoutID: String
    let currentProjectionText: String
    let alternativeProjectionText: String
    let frameCount: Int
    let currentLayoutWasActive: Bool
    let alternativeIsDifferent: Bool
    let currentLayoutIsTrusted: Bool
    var hasEnoughFrames: Bool {
        frameCount >= 3
    }
    var projectionAreDifferent: Bool {
        currentProjectionText != alternativeProjectionText
    }
    var canConsiderSwitch: Bool {
        hasEnoughFrames && alternativeIsDifferent && projectionAreDifferent && !currentLayoutIsTrusted
    }
}
