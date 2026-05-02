//
//  HIDSequenceSignal.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 2.5.2026.
//

import Foundation

struct HIDSequenceSignal {
    let shouldConsiderSwitch: Bool
    let confidence: Double
    let reason: String
}
final class HIDSequenceSignalAnalyzer {
    func analyze(frames: [KeyInputFrame]) -> HIDSequenceSignal {
        guard frames.count >= 3 else {
            return HIDSequenceSignal(
                shouldConsiderSwitch: false, confidence: 0.0, reason: "Not enough HID frames"
            )
        }
        let recentFrames = Array(frames.suffix(4))
        let timingScore = typingTimingScore(frames: recentFrames)
        let movementScore = keyMovementScore(frames: recentFrames)
        let confidence = min(1.0, timingScore + movementScore)
        return HIDSequenceSignal(
            shouldConsiderSwitch: confidence >= 0.5,
            confidence: confidence,
            reason: "HID sequence signal timing: \(timingScore), movement: \(movementScore)"
     )
    }
    private func typingTimingScore(frames: [KeyInputFrame]) -> Double {
        guard frames.count > 1 else { return 0.0 }
        var goodIntervals = 0
        for index in 1..<frames.count {
            let previous = frames[index - 1]
            let current = frames[index]
            let delta = current.timestamp - previous.timestamp
            if delta > 0.03 && delta < 0.35 {
                goodIntervals += 1
            }
        }
        return Double(goodIntervals) / Double(frames.count - 1) * 0.4
    }
    private func keyMovementScore(frames: [KeyInputFrame]) -> Double {
        guard frames.count > 1 else { return 0.0 }
        var movement = 0
        for index in 1..<frames.count {
            let previous = frames[index - 1]
            let current = frames[index]
            let distance = abs(Int(current.keyCode) - Int(previous.keyCode))
            if distance > 0 && distance < 30 {
                movement += 1
            }
        }
        return Double(movement) / Double(frames.count - 1) * 0.4
    }
}
