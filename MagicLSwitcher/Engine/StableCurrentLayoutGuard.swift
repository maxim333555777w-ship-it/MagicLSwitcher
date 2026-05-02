//
//  StableCurrentLayoutGuard.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 2.5.2026.
//

import Foundation

final class StableCurrentLayoutGuard {
    private var framesInSeries: Int =  0
    private var isLocked: Bool = false
    private let lockAfterFrames: Int = 3
    func registerTextFrame() {
        framesInSeries += 1
        if framesInSeries >= lockAfterFrames {
            isLocked = true
        }
    }
    func resetSeries() {
        framesInSeries = 0
        isLocked = false
    }
    func shouldBlockSwitch() -> Bool {
        isLocked
    }
}
