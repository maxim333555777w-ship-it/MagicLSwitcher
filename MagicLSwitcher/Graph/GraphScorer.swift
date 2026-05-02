//
//  GraphScorer.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 21.4.2026.
//

import Foundation

struct GraphScorer {
    func score(text: String) -> Double {
        guard !text.isEmpty else { return 0.0 }
        let latinCount = countLatinLetters(in: text)
        let cyrillicCount = countCyrillicLetters(in: text)
        let digitCount = countDigits(in: text)
        let symbolCount = countSymbols(in: text)
        
        let totalLetters = latinCount + cyrillicCount
        let totalCount = text.count
        
        var score = 0.0
        
        score += Double(totalLetters) * 1.5
        
        if latinCount > 0 && cyrillicCount > 0 {
            score -= 4.0
        }
        if latinCount > 0 && cyrillicCount == 0 {
            score += 2.0
        }
        if cyrillicCount > 0 && latinCount == 0 {
            score += 2.0
        }
        score -= Double(symbolCount) * 1.2
        score -= Double(digitCount) * 0.8
        
        if totalCount >= 3 {
            score += 2.0
        }
        if totalCount >= 5 {
            score += 1.5
        }
        return score
    }
    private func countLatinLetters(in text: String) -> Int {
        text.unicodeScalars.filter { scalar in
            (65...90).contains(scalar.value) || (97...122).contains(scalar.value)
        }.count
    }
   private func countCyrillicLetters(in text: String) -> Int {
        text.unicodeScalars.filter { scalar in
            (0x0400...0x04FF).contains(scalar.value)
        }.count
    }
    private func countDigits(in text: String) -> Int {
        text.filter { $0.isNumber }.count
    }
    private func countSymbols(in text: String) -> Int {
        text.filter { char in
            !char.isLetter && !char.isNumber && !char.isWhitespace
        }.count
    }
}
