//
//  SwitchDecisionEngine.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 23.4.2026.
//

import Foundation

final class SwitchDecisionEngine {
    private let minFrames: Int = 3
    private let switchThreshold: Double = 0.75
    private let signalAnalyzer = SwitchSignalAnalyzer()
    
    func decide(projection: [LayoutProjection]) -> LayoutSwitchDecision {
        guard !projection.isEmpty else {
            return LayoutSwitchDecision(
                action: .none,
                confidence: 0.0,
                reason: "No projection"
            )
        }
        let length = projection.first?.length ?? 0
        guard length >= minFrames else {
            return LayoutSwitchDecision(
                action: .none,
                confidence: 0.0,
                reason: "Not enough input"
            )
        }
        let scored = projection.map { projection in
            (projection, score(projection: projection))
        }
        for item in scored {
            print("Projection", item.0.layoutID, item.0.text, "score:", item.1)
        }
        let sorted = scored.sorted { $0.1 > $1.1 }
        guard sorted.count >= 2 else {
            return LayoutSwitchDecision(
            action: .none,
            confidence: 0.0,
            reason: "Not enough candidates"
            )
        }
        let best = sorted[0]
        let second = sorted[1]
        let scorediff = best.1 - second.1
        let projectionDiff = comper(best: best.0, second: second.0)
        let confidence = normalize(diff: scorediff) + projectionDiff
        let finalConfidence = min(1.0, confidence)
        
        if confidence > switchThreshold {
            return LayoutSwitchDecision(
                action: .switchLayout,
                targetLayoutID: best.0.layoutID,
                confidence: finalConfidence,
                reason: "Projection dominance detected"
            )
        }
        return LayoutSwitchDecision(
            action: .wait,
            confidence: confidence,
            reason: "Confidence too low"
        )
    }
    func decide(projections: [LayoutProjection], evidence: SwitchEvidence) -> LayoutSwitchDecision {
        let signal = signalAnalyzer.analyze(
            evidence: evidence,
            frames: projections.first?.frames ?? []
        )
        guard signal.shouldSwitch else {
            return LayoutSwitchDecision(
                action: .wait,
                confidence: signal.confidence,
                reason: signal.reason
            )
        }
        guard evidence.canConsiderSwitch else {
            return LayoutSwitchDecision(
                action: .wait,
                confidence: 0.0,
                reason: "Evidence is not enough"
            )
        }
        return LayoutSwitchDecision(
            action: .switchLayout,
            targetLayoutID: evidence.alternativeLayoutID,
            confidence: signal.confidence,
            reason: signal.reason
        )
        //    if evidence.currentProjectionText.count >= 3 {
        //    return LayoutSwitchDecision(
        //        action: .wait,
       //         confidence: 0.0,
       //         reason: "Current projection is stable"
      //      )
     //   }
    //    return LayoutSwitchDecision(
     //       action: .switchLayout,
     //       targetLayoutID: evidence.alternativeLayoutID,
     //       confidence: 0.85,
      //      reason: "Alternative projection differs from current projection"
       // )
    }
    private func score(projection: LayoutProjection) -> Double {
        let text = projection.text
        guard !text.isEmpty else { return 0.0 }
        var score = 0.0
        score += Double(text.count) * 0.5
        score += keyStreamScore(frames: projection.frames)
        return score
    }
    private func normalize(diff: Double) -> Double {
        let maxDiff = 10.0
        let normalized = diff / maxDiff
        return max(0.0, min(1.0, normalized))
    }
    private func keyStreamScore(frames: [KeyInputFrame]) -> Double {
        guard frames.count > 1 else { return 0.0 }
        var score = 0.0
        for index in 1..<frames.count {
            let previous = frames[index - 1]
            let current = frames[index]
            let distance = abs(Int(current.keyCode) - Int(previous.keyCode))
            if distance <= 3 {
                score += 1.0
            } else if distance <= 8 {
                score += 0.4
            } else {
                score -= 0.6
            }
            let timeDelta = current.timestamp - previous.timestamp
            if timeDelta > 0.02 && timeDelta < 0.35 {
                score += 0.5
            } else {
                score -= 0.2
            }
        }
        return score
    }
    private func comper(best: LayoutProjection, second: LayoutProjection) -> Double {
        let bestLength = Double(best.text.count)
        let secondLengt = Double(second.text.count)
        guard bestLength > 0 || secondLengt > 0 else { return 0.0 }
        let lengthDifference = abs(bestLength - secondLengt)
        if lengthDifference == 0 {
            return 0.2
        } else {
            return min(1.0, lengthDifference / max(bestLength, secondLengt))
        }
    }
}
    

