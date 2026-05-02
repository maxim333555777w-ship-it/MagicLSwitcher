//
//  AppDelegate.swift
//  MagicLSwitcherIM
//
//  Created by Khachatur Abramian on 19.4.2026.
//

import Cocoa
import InputMethodKit

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let serverManager = IMKServerManager()
    func applicationDidFinishLaunching(_ notification: Notification) {
        serverManager.start()
    }
}
