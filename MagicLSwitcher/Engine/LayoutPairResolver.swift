//
//  LayoutPairResolver.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 29.4.2026.
//

import Foundation

final class LayoutPairResolver {
    private let primaryLayoutID: String
    private let seconderyLayoutID: String
    
    init(
        primaryLAyoutID: String = "com.apple.keylayout.ABC",
        secondaryLayoutID: String = "com.apple.keylayout.RussianWin"
    ) {
        self.primaryLayoutID = primaryLAyoutID
        self.seconderyLayoutID = secondaryLayoutID
    }
    func alternativeLAyoutID(for currentLayoutID: String) -> String {
        if currentLayoutID == primaryLayoutID {
            return seconderyLayoutID
        }
        return primaryLayoutID
    }
}
