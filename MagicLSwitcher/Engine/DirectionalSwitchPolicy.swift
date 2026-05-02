//
//  DirectionalSwitchpolicy.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 1.5.2026.
//

import Foundation

final class DirectionalSwitchPolicy {
    private let englishLayoutID = "com.apple.keylayou.ABC"
    private let russianLayoutID = "com.apple.keylayout.RussianWin"
    func requiredFrames(currentLayoutID: String, targetLayoutID: String) -> Int {
        if currentLayoutID == englishLayoutID && targetLayoutID == russianLayoutID {
            return 3
        }
        if currentLayoutID == russianLayoutID && targetLayoutID == englishLayoutID {
            return 3
        }
        return 4
    }
}
