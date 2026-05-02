//
//  SwitchRuntime.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 28.4.2026.
//

import Foundation

final class SwitchRuntime {
    private enum RuntimeState {
        case observing
        case frozen
    }
    private var state: RuntimeState = .observing
    private var frozenKeyCount: Int = 0
    private let frozenKeyLimit: Int = 3
    private var frozenUntil: TimeInterval = 0
    private let frozenDuration: TimeInterval = 0.5
    private let buffer = InputFrameBuffer(maxSize: 8)
    private let engine = SwitchDecisionEngine()
    private let resolver = LayoutPairResolver()
    private let directionPolicy = DirectionalSwitchPolicy()
    private let stableGuard = StableCurrentLayoutGuard()
    private var lastSwitchTime: TimeInterval = 0
    private let switchCoolDown: TimeInterval = 0.8
    private var lastTargetLayoutID: String?
    private let directionLockTime: TimeInterval = 1.5
    private var candidateLayouID: String?
    private var candidateHits: Int = 0
    private let requiredCandidateHits: Int = 1
    private var trustedLayouID: String?
    private var trustedKeyBudget: Int = 0
    private let trustedKeyLimit: Int = 3
    private let seriesGate = SeriesDecisionGate()
    
    func handle(frame: KeyInputFrame) -> LayoutSwitchDecision {
        buffer.append(frame)
        
        guard let currentLayoutID = KeyboardLayoutBridge.currentLayoutID() else {
            return LayoutSwitchDecision(
                action: .none,
                confidence: 0.0,
                reason: "Current layout unavalible"
            )
        }
        let alternativeLayoutID = resolver.alternativeLAyoutID(for: currentLayoutID)
        let frames = buffer.currentFrames()
        let currentProjection = LayoutProjection.build(layoutID: currentLayoutID, frames: frames)
        let alternativeProjection = LayoutProjection.build(layoutID: alternativeLayoutID, frames: frames)
        let currentLayoutIsTrusted = trustedLayouID == currentLayoutID && trustedKeyBudget > 0
        let evidence = makeEvidence(
            currentLayoutID: currentLayoutID,
            alternativeLayoutID: alternativeLayoutID,
            currentProjection: currentProjection,
            alternativeProjection: alternativeProjection,
            currentLayoutIsTrusted: currentLayoutIsTrusted
        )
        print("Evidence can consider:", evidence.canConsiderSwitch)
        print("Evidence current:", evidence.currentProjectionText)
        print("Evidence alternative:", evidence.alternativeProjectionText)
        return engine.decide(projections: [currentProjection, alternativeProjection], evidence: evidence)
    }
    private func makeEvidence(
        currentLayoutID: String,
        alternativeLayoutID: String,
        currentProjection: LayoutProjection,
        alternativeProjection: LayoutProjection,
        currentLayoutIsTrusted: Bool
    ) -> SwitchEvidence {
        SwitchEvidence(
            currentLayoutID: currentLayoutID,
            alternativeLayoutID: alternativeLayoutID,
            currentProjectionText: currentProjection.text,
            alternativeProjectionText: alternativeProjection.text,
            frameCount: currentProjection.frames.count,
            currentLayoutWasActive: true,
            alternativeIsDifferent: currentLayoutID != alternativeLayoutID,
            currentLayoutIsTrusted: currentLayoutIsTrusted
        )
    }
    func reset() {
        buffer.clear()
    }
    func handleAndApply(frame: KeyInputFrame) -> LayoutSwitchDecision {
        let now = Date().timeIntervalSince1970
        if shouldIgnore(frame: frame) {
         //   if let currentLayoutID = KeyboardLayoutBridge.currentLayoutID() {
           //    trustedLayouID = currentLayoutID
            //   trustedKeyBudget = trustedKeyLimit
            buffer.clear()
            stableGuard.resetSeries()
            seriesGate.reset()
            
            return LayoutSwitchDecision(
                action: .wait,
                confidence: 0.0,
                reason: "Ignored non-text key"
            )
        }
        if trustedKeyBudget > 0 {
            trustedKeyBudget -= 1
            if trustedKeyBudget == 0 {
                trustedLayouID = nil
            }
        }
    //    }
        if state == .frozen {
            frozenKeyCount += 1
            if frozenKeyCount < frozenKeyLimit {
                buffer.append(frame)
                return LayoutSwitchDecision(
                    action: .wait,
                    confidence: 0.0,
                    reason: "Runtime is frozen after switch"
                )
            } else {
                state = .observing
                frozenKeyCount = 0
                buffer.clear()
            }
        }
      //  guard decision.action == .switchLayout,
        //      let targetLayoutID = decision.targetLayoutID
             // let currentLayoutID = KeyboardLayoutBridge.currentLayoutID()
      //  else {
       //     return decision
    //    }
      //  if lastTargetLayoutID == currentLayoutID {
       //     return LayoutSwitchDecision(
            //    action: .none,
            //    confidence: decision.confidence,
            //    reason: "Target layout is already active"
        //    )
      //  }
        seriesGate.registerFrame()
        let decision = handle(frame: frame)
        guard seriesGate.canSwitchInCurrentSeries() else {
            return LayoutSwitchDecision(
                action: .wait,
                confidence: 0.0,
                reason: "Series decision window closed"
            )
        }
        if stableGuard.shouldBlockSwitch() {
            return LayoutSwitchDecision(
                action: .wait,
                confidence: 0.0,
                reason: "Stable current layout guard active"
            )
        }
        guard decision.action == .switchLayout,
              let targetLayoutID = decision.targetLayoutID
        else {
            return decision
        }
        let canSwitchByCooldown = now - lastSwitchTime >= switchCoolDown
        guard canSwitchByCooldown else {
            return LayoutSwitchDecision(
                action: .wait,
                targetLayoutID: targetLayoutID,
                confidence: decision.confidence,
                reason: "Switch cooldown active"
            )
        }
        if let lastTargetLayoutID,
          lastTargetLayoutID != targetLayoutID,
           now - lastSwitchTime < directionLockTime {
           return LayoutSwitchDecision(
                action: .wait,
               targetLayoutID: targetLayoutID,
               confidence: decision.confidence,
               reason: "Direction lock active"
           )
       }
        if candidateLayouID == targetLayoutID {
            candidateHits += 1
        } else {
            candidateLayouID = targetLayoutID
            candidateHits = 1
        }
        let requiredHits = directionPolicy.requiredFrames(currentLayoutID: KeyboardLayoutBridge.currentLayoutID() ?? "", targetLayoutID: targetLayoutID
        )
        guard candidateHits >= requiredHits else {
            return LayoutSwitchDecision(
                action: .wait,
                targetLayoutID: targetLayoutID,
                confidence: decision.confidence,
                reason: "Waiting for stable switch candidate"
            )
        }
        let didSwitch = KeyboardLayoutBridge.selectLayoutID(targetLayoutID)
        if didSwitch {
            seriesGate.reset()
            lastSwitchTime = now
            lastTargetLayoutID = targetLayoutID
            state = .frozen
            frozenKeyCount = 0
          //  frozenUntil = now + frozenDuration
            candidateLayouID = nil
            candidateHits = 0
            trustedLayouID = targetLayoutID
            trustedKeyBudget = trustedKeyLimit
            buffer.clear()
        }
        print("Apply switch:", didSwitch, "target:", targetLayoutID)
        return decision
        }
    private func shouldIgnore(frame: KeyInputFrame) -> Bool {
        let ignoreKeyCodes: Set<UInt16> = [
            36, 48, 49, 51, 53, 123, 124, 125, 126
        ]
        return ignoreKeyCodes.contains(frame.keyCode)
    }
    }

