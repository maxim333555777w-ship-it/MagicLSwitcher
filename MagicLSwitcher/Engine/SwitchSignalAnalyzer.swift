//
//  SwitchSignalAnalyzer.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 1.5.2026.
//

import Foundation

struct SwitchSignal {
    let shouldSwitch: Bool
    let confidence: Double
    let reason: String
}
final class SwitchSignalAnalyzer {
    private let minFrames: Int = 3
    private let strongConfidence: Double = 0.85
    private let hidAnalyzer = HIDSequenceSignalAnalyzer()
    
    func analyze(evidence: SwitchEvidence, frames: [KeyInputFrame]) -> SwitchSignal {
        guard evidence.hasEnoughFrames else {
            return SwitchSignal(
                shouldSwitch: false,
                confidence: 0.0,
                reason: "Not enough frames"
            )
        }
        guard evidence.alternativeIsDifferent else {
            return SwitchSignal(
                shouldSwitch: false,
                confidence: 0.0,
                reason: "Alternative layout is not different"
            )
        }
        guard evidence.projectionAreDifferent else {
            return SwitchSignal(
                shouldSwitch: false, confidence: 0.0, reason: "Projection are equal"
            )
        }
        guard !evidence.currentLayoutIsTrusted else {
            return SwitchSignal(
                shouldSwitch: false, confidence: 0.0, reason: "Current layout is trusted"
            )
        }
        let hidSignal = hidAnalyzer.analyze(frames: frames)
        guard hidSignal.shouldConsiderSwitch else {
            return SwitchSignal(
                shouldSwitch: false,
                confidence: hidSignal.confidence,
                reason: hidSignal.reason
            )
        }
        return SwitchSignal(
            shouldSwitch: true,
            confidence: hidSignal.confidence,
            reason: hidSignal.reason
        )
    }
}
