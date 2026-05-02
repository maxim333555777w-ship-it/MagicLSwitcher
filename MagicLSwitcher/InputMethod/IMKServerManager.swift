//
//  IMKServerManager.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 18.4.2026.
//

import Foundation
import InputMethodKit

final class IMKServerManager {
    private var server: IMKServer?
    
    func start() {
        server = IMKServer(name: "MagicLSwitcher_Connection", bundleIdentifier: Bundle.main.bundleIdentifier)
        print("IMK Server started")
    }
}
