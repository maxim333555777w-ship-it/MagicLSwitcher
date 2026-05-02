//
//  SeriesDecisionGate.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 2.5.2026.
//

import Foundation

final class SeriesDecisionGate {
    private var frameCoutSeries: Int = 0
    private var isClosed: Bool = false
    private let decisionWindowLimit: Int = 4
    
    func registerFrame() {
        frameCoutSeries += 1
        if frameCoutSeries > decisionWindowLimit {
            isClosed = true
        }
    }
    func reset() {
        frameCoutSeries = 0
        isClosed = false
    }
    func canSwitchInCurrentSeries() -> Bool {
        !isClosed
    }
}
