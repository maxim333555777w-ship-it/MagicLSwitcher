//
//  SwitcherInputController.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 18.4.2026.
//

import InputMethodKit

class SwitcherInputController: IMKInputController {
    private let compositionBuffer = CompositionBuffer()
    private let decisionEngine = InputMethodDecisionEngine()
    private let keyboardTranslator = KeyboardTranslator()
    override func inputText(_ string: String!, client sender: Any!) -> Bool {
        let text = string ?? ""
        print("INPUT:", text)
        return false
    }
}
