//
//  InputFrameBuffer.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 28.4.2026.
//

import Foundation

final class InputFrameBuffer {
    private let maxSize: Int
    private var frames: [KeyInputFrame] = []
    
    init(maxSize: Int = 8) {
        self.maxSize = maxSize
    }
    func append(_ frame: KeyInputFrame) {
        frames.append(frame)
        if frames.count > maxSize {
            frames.removeFirst()
        }
    }
    func currentFrames() -> [KeyInputFrame] {
        frames
    }
    func clear() {
        frames.removeAll()
    }
    var count: Int {
        frames.count
    }
    var isEmty: Bool {
        frames.isEmpty
    }
}
