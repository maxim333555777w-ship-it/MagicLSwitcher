//
//  MagicLSwitcherApp.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 24.3.2026.
//

import SwiftUI

@main
struct MagicLSwitcherApp: App {
    let imkServerManager = IMKServerManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                 //   imkServerManager.start()
                }
        }
    }
}
