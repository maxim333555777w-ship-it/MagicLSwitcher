//
//  CompositionBuffer.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 18.4.2026.
//

import Foundation

final class CompositionBuffer {
    private(set) var text: String = ""
    func add(_ char: Character) {
        text.append(char)
    }
    func clear() {
        text = ""
    }
    func removeLast() {
        guard !text.isEmpty else { return }
        text.removeLast()
    }
}
